#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <cvhaartraining.h>
#include <_cvhaartraining.h> // Load CvVecFile
void icvVec2Img( const char* vecname, const char* outformat, int width, int height );

// Extract images from a vec file
void icvVec2Img( const char* vecname, const char* outformat, int width, int height )
{
    CvVecFile vec;
    CvMat* sample;
    char outfilename[PATH_MAX];
    short tmp;

    vec.input = fopen( vecname, "rb" );
    if ( vec.input == NULL )
    {
        fprintf( stderr, "ERROR: Input file %s does not exist or not readable.\n", vecname);
        exit(1);
    }
    fread( &vec.count, sizeof( vec.count ), 1, vec.input );
    fread( &vec.vecsize, sizeof( vec.vecsize ), 1, vec.input );
    fread( &tmp, sizeof( tmp ), 1, vec.input );
    fread( &tmp, sizeof( tmp ), 1, vec.input );

    if( !feof( vec.input ) )
    {
        vec.last = 0;
        vec.vector = (short*) cvAlloc( sizeof( *vec.vector ) * vec.vecsize );
        if( vec.vecsize != width * height )
        {
            fprintf( stderr, "ERROR: The size of images inside of vec files does not match with %d x %d, but %d. \n", height, width, vec.vecsize );
            exit(1);
        }
        sample = cvCreateMat( height, width, CV_8UC1 );
        //cvNamedWindow( "Sample", CV_WINDOW_AUTOSIZE );
        for( int i = 0; i < vec.count; i++ )
        {
            icvGetHaarTraininDataFromVecCallback( sample, &vec );
            sprintf( outfilename, outformat, i + 1 );
            printf( "%s\n", outfilename );
            cvSaveImage( outfilename, sample );
            //cvShowImage( "Sample", sample ); cvWaitKey( 0 );
        }
        cvReleaseMat( &sample );
        cvFree( (void**) &vec.vector );
    }
    fclose( vec.input );
}

int main(int argc, char **argv){
    char *vecname   = NULL;
    char *outformat = NULL;
    int width       = 24;
    int height      = 24;
    int i           = 0;

    if( argc == 1 )
    {
        printf( "Usage: %s\n  <input_vec_filename>\n"
            "  <output_filename_format>\n"
            "  [-w <sample_width = %d>] [-h <sample_height = %d>]\n",
            argv[0], width, height );
        printf( "The output filename format is a string having one %%d such as 'samples%%04d.png'.\n"
            "The image file format is automatically determined by the extension.\n" );
        return 0;
    }
    for( i = 1; i < argc; ++i )
    {
        if( !strcmp( argv[i], "-w" ) )
        {
            width = atoi( argv[++i] );
        } 
        else if( !strcmp( argv[i], "-h" ) )
        {
            height = atoi( argv[++i] );
        } 
        else if( vecname == NULL )
        {
            vecname = argv[i];
        }
        else if( outformat == NULL )
        {
            outformat = argv[i];
        }
    }
    if ( vecname == NULL )
    {
        fprintf( stderr, "ERROR: No input vec file. \n" );
        exit(1);
    }
    if ( outformat == NULL )
    {
        fprintf( stderr, "ERROR: Not output filename format. \n" );
        exit(1);
    }
    icvVec2Img( vecname, outformat, width, height );
    return 0;
}
