#include "cv.h"
#include "highgui.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <time.h>
#include <ctype.h>

#ifdef _EiC
#define WIN32
#endif

static CvMemStorage* storage = 0;
static CvHaarClassifierCascade* cascade = 0;

void detect_and_draw( IplImage* img, double scale_factor, int min_neighbors, int flags, CvSize min_size );

const char* cascade_name =
    "haarcascade_frontalface_alt.xml";
/*    "haarcascade_profileface.xml";*/

int main( int argc, char** argv )
{
    CvCapture* capture = 0;
    IplImage *frame, *frame_copy = 0;
    int optlen = strlen("--cascade=");
    const char* input_name = "0";
    int i;
    double scale_factor = 1.1;
    int min_neighbors = 1;
    int flags = 0;/*CV_HAAR_DO_CANNY_PRUNING*/
    CvSize min_size = cvSize(0,0);

    if( argc == 1 )
    {
        fprintf( stderr, "ERROR: Could not load classifier cascade\n" );
        fprintf( stderr,
                 "Usage: facedetect  "
                 "--cascade=\"<cascade_xml_path>\" or -c <cascade_xml_path>\n"
                 "  [ -sf < scale_factor = %f > ]\n"
                 "  [ -mn < min_neighbors = %d > ]\n"
                 "  [ -fl < flags = %d > ]\n"
                 "  [ -ms < min_size = %d %d > ]\n"
                 "  [ filename | camera_index = %s ]\n",
                 scale_factor, min_neighbors, flags, min_size.width, min_size.height, input_name );
        fprintf( stderr, "See also: cvHaarDetectObjects() about option parameters.\n" );
        return -1;
    }

    for( i = 1; i < argc; i++ )
    {
        if( !strncmp( argv[i], "--cascade=", optlen ) )
        {
            cascade_name = argv[++i] + optlen;
        }
        else if( !strcmp( argv[i], "-c" ) )
        {
            cascade_name = argv[++i];
        }
        else if( !strcmp( argv[i], "-sf" ) )
        {
            scale_factor = (float) atof( argv[++i] );
        }
        else if( !strcmp( argv[i], "-mn" ) )
        {
            min_neighbors = atoi( argv[++i] );
        }
        else if( !strcmp( argv[i], "-fl" ) )
        {
            flags = CV_HAAR_DO_CANNY_PRUNING;
        }
        else if( !strcmp( argv[i], "-ms" ) )
        {
            min_size = cvSize( atoi( argv[++i] ), atoi( argv[++i] ) );
        }
        else 
        {
            input_name = argv[i];
        }
    }

    cascade = (CvHaarClassifierCascade*)cvLoad( cascade_name, 0, 0, 0 );
    storage = cvCreateMemStorage(0);
    
    if( !input_name || (isdigit(input_name[0]) && input_name[1] == '\0') )
        capture = cvCaptureFromCAM( !input_name ? 0 : input_name[0] - '0' );
    else
        capture = cvCaptureFromAVI( input_name ); 

    cvNamedWindow( "result", 1 );

    if( capture )
    {
        for(;;)
        {
            if( !cvGrabFrame( capture ))
                break;
            frame = cvRetrieveFrame( capture );
            if( !frame )
                break;
            if( !frame_copy )
                frame_copy = cvCreateImage( cvSize(frame->width,frame->height),
                                            IPL_DEPTH_8U, frame->nChannels );
            if( frame->origin == IPL_ORIGIN_TL )
                cvCopy( frame, frame_copy, 0 );
            else
                cvFlip( frame, frame_copy, 0 );
            
            detect_and_draw( frame_copy, scale_factor, min_neighbors, flags, min_size );

            if( cvWaitKey( 10 ) >= 0 )
                break;
        }

        cvReleaseImage( &frame_copy );
        cvReleaseCapture( &capture );
    }
    else
    {
        const char* filename = input_name ? input_name : (char*)"lena.jpg";
        IplImage* image = cvLoadImage( filename, 1 );

        if( image )
        {
            detect_and_draw( image, scale_factor, min_neighbors, flags, min_size );
            cvWaitKey(0);
            cvReleaseImage( &image );
        }
        else
        {
            /* assume it is a text file containing the
               list of the image filenames to be processed - one per line */
            FILE* f = fopen( filename, "rt" );
            if( f )
            {
                char buf[1000+1];
                while( fgets( buf, 1000, f ) )
                {
                    int len = (int)strlen(buf);
                    while( len > 0 && isspace(buf[len-1]) )
                        len--;
                    buf[len] = '\0';
                    image = cvLoadImage( buf, 1 );
                    if( image )
                    {
                        detect_and_draw( image, scale_factor, min_neighbors, flags, min_size );
                        cvWaitKey(0);
                        cvReleaseImage( &image );
                    }
                }
                fclose(f);
            }
        }

    }
    
    cvDestroyWindow("result");

    return 0;
}

void detect_and_draw( IplImage* img, double scale_factor, int min_neighbors, int flags, CvSize min_size )
{
    static CvScalar colors[] = 
    {
        {{0,0,255}},
        {{0,128,255}},
        {{0,255,255}},
        {{0,255,0}},
        {{255,128,0}},
        {{255,255,0}},
        {{255,0,0}},
        {{255,0,255}}
    };

    double scale = 1.3;
    IplImage* gray = cvCreateImage( cvSize(img->width,img->height), 8, 1 );
    IplImage* small_img = cvCreateImage( cvSize( cvRound (img->width/scale),
                         cvRound (img->height/scale)), 8, 1 );
    int i;

    cvCvtColor( img, gray, CV_BGR2GRAY );
    cvResize( gray, small_img, CV_INTER_LINEAR );
    cvEqualizeHist( small_img, small_img );
    cvClearMemStorage( storage );

    if( cascade )
    {
        double t = (double)cvGetTickCount();
        CvSeq* faces = cvHaarDetectObjects( small_img, cascade, storage, 
                                            scale_factor, min_neighbors, flags, min_size );
                                            //1.1, 2, 0/*CV_HAAR_DO_CANNY_PRUNING*/, cvSize(30, 30) );
        t = (double)cvGetTickCount() - t;
        printf( "detection time = %gms\n", t/((double)cvGetTickFrequency()*1000.) );
        for( i = 0; i < (faces ? faces->total : 0); i++ )
        {
            CvRect* r = (CvRect*)cvGetSeqElem( faces, i );
            CvPoint center;
            int radius;
            center.x = cvRound((r->x + r->width*0.5)*scale);
            center.y = cvRound((r->y + r->height*0.5)*scale);
            radius = cvRound((r->width + r->height)*0.25*scale);
            cvCircle( img, center, radius, colors[i%8], 3, 8, 0 );
        }
    }

    cvShowImage( "result", img );
    cvReleaseImage( &gray );
    cvReleaseImage( &small_img );
}
