#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <cvhaartraining.h>
#include <_cvhaartraining.h> // CvVecFile
// Write a vec header into the vec file //cvsamples.cpp -> cvhaartraining.lib
void icvWriteVecHeader( FILE* file, int count, int width, int height );
// Write a sample image into file in the vec format //cvsamples.cpp -> cvhaartraining.lib
void icvWriteVecSample( FILE* file, CvArr* sample );

// Append the body of the input vec to the ouput vec
void icvAppendVec( CvVecFile &in, CvVecFile &out, int *showsamples, int winheight, int winwidth )
{
	CvMat* sample;

	if( *showsamples )
	{
		cvNamedWindow( "Sample", CV_WINDOW_AUTOSIZE );
	}
	if( !feof( in.input ) )
	{
		in.last = 0;
		in.vector = (short*) cvAlloc( sizeof( *in.vector ) * in.vecsize );
		if ( *showsamples )
		{
			if ( in.vecsize != winheight * winwidth )
			{
				fprintf( stderr, "-show: the size of images inside of vec files does not match with %d x %d, but %d\n", winheight, winwidth, in.vecsize );
				exit(1);
			}
			sample = cvCreateMat( winheight, winwidth, CV_8UC1 );
		} 
		else 
		{
			sample = cvCreateMat( in.vecsize, 1, CV_8UC1 );
		}
		for( int i = 0; i < in.count; i++ )
		{
			icvGetHaarTraininDataFromVecCallback( sample, &in );
			icvWriteVecSample ( out.input, sample );
			if( *showsamples )
			{
				cvShowImage( "Sample", sample );
				if( cvWaitKey( 0 ) == 27 )
				{ 
					*showsamples = 0; 
				}
			}
		}
		cvReleaseMat( &sample );
		cvFree( (void**) &in.vector );
	}
}

void icvMergeVecs( char* infoname, const char* vecfilename, int showsamples, int width, int height )
{
	char filename[PATH_MAX];
	int i = 0;
	int filenum = 0;
	short tmp; 
	FILE *info;
	CvVecFile outvec;
	CvVecFile invec;
	int prev_vecsize;

	// fopen input and output file
	info = fopen( infoname, "r" );
	if ( info == NULL )
	{
		fprintf( stderr, "Input file %s does not exist or not readable\n", infoname );
		exit(1);
	}
	outvec.input = fopen( vecfilename, "wb" );
	if ( outvec.input == NULL )
	{
		fprintf( stderr, "Output file %s is not writable\n", vecfilename );
		exit(1);
	}

	// Header
	rewind( info );
	outvec.count = 0;
	for ( filenum = 0; ; filenum++ )
	{
		if ( fscanf( info, "%s", filename ) == EOF )
        {
			break;
		}
		invec.input = fopen( filename, "rb" );
		if ( invec.input == NULL )
		{
			fprintf( stderr, "Input file %s does not exist or not readable\n", filename );
			exit(1);
		}
		fread( &invec.count,   sizeof( invec.count )  , 1, invec.input );
		fread( &invec.vecsize, sizeof( invec.vecsize ), 1, invec.input );
		fread( &tmp, sizeof( tmp ), 1, invec.input );
		fread( &tmp, sizeof( tmp ), 1, invec.input );

		outvec.count += invec.count;
		if( i > 0 &&  invec.vecsize != prev_vecsize )
		{
			fprintf( stderr, "The size of images in %s(%d) is different with the previous vec file(%d).\n", filename, invec.vecsize, prev_vecsize );
			exit(1);
		}
		prev_vecsize = invec.vecsize;
		fclose( invec.input );
	}
	outvec.vecsize = invec.vecsize;
	icvWriteVecHeader( outvec.input, outvec.count, outvec.vecsize, 1);

	// Contents
	rewind( info );
	outvec.count = 0;
	for ( i = 0; i < filenum ; i++ )
	{
		if (fscanf( info, "%s", filename ) == EOF) {
			break;
		}
		invec.input = fopen( filename, "rb" );
		fread( &invec.count,   sizeof( invec.count )  , 1, invec.input );
		fread( &invec.vecsize, sizeof( invec.vecsize ), 1, invec.input );
		fread( &tmp, sizeof( tmp ), 1, invec.input );
		fread( &tmp, sizeof( tmp ), 1, invec.input );

		icvAppendVec( invec, outvec, &showsamples, width, height );
		fclose( invec.input );
	}
	fclose( outvec.input );
}

int main( int argc, char **argv ) 
{
	int i,j = 0;
	char *infoname = NULL;
	char *vecfilename = NULL;
	int showsamples = 0;
	int width = 24;
	int height = 24;

	if( argc == 1 )
	{
		printf( "Usage: %s\n  <vec_collection_file_name>\n"
			"  <output_vec_file_name>\n"
			"  [-show] [-w <sample_width = %d>] [-h <sample_height = %d>]\n",
			argv[0], width, height );
		return 0;
	}
	for( i = 1; i < argc; ++i )
	{
		if( !strcmp( argv[i], "-show" ) )
		{
			showsamples = 1;
			width = atoi( argv[++i] );
			height = atoi( argv[++i] );
		} 
		else if( !strcmp( argv[i], "-w" ) )
		{
			width = atoi( argv[++i] );
		} 
		else if( !strcmp( argv[i], "-h" ) )
		{
			height = atoi( argv[++i] );
		} 
		else 
		{
			if ( j == 0 )
			{
				infoname = argv[i];
			}
			else
			{
				vecfilename  = argv[i];
			}
			j++;
		}
	}
	if( infoname == NULL )
	{
		fprintf( stderr, "No input file\n");
		exit(1);
	}
	if( vecfilename == NULL )
	{
		fprintf( stderr, "No output file\n");
		exit(1);
	}
	icvMergeVecs( infoname, vecfilename, showsamples, width, height );
	return 0;
}
