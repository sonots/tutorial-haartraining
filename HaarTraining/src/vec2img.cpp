#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <cvhaartraining.h>
#include <_cvhaartraining.h> // CvVecFile
#include <string> // use string for easiness
using namespace std;

// *.vec -> *_015.png
string outputfilename( const char* outdir, const char* vec, int id )
{
	char no[3];
	string outfile = string( outdir ) + "/" + string( vec );
	outfile.erase(outfile.size()-4, 4); // erase .vec
	sprintf(no, "%03d", id);
	outfile = outfile + "_" + no + ".png";
	return outfile;
}

// Extract images from a vec file
void icvVec2Img( const char* vecname, const char* outdir, int width, int height )
{
	CvVecFile vec;
	CvMat* sample;
	string outputfile;
	short tmp;
	vec.input = fopen( vecname, "rb" );
	if ( vec.input == NULL )
	{
		fprintf( stderr, "Input file %s does not exist or not readable\n", vecname);
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
			fprintf( stderr, "The size of images inside of vec files does not match with %d x %d, but %d\n", height, width, vec.vecsize );
			exit(1);
		}
		sample = cvCreateMat( height, width, CV_8UC1 );
		for(int i = 0; i < vec.count; i++ )
		{
			icvGetHaarTraininDataFromVecCallback( sample, &vec );
			outputfile = outputfilename( outdir, vecname, i+1 );
			printf( "%s\n", outputfile.c_str() );
			cvSaveImage(outputfile.c_str(),  sample);
		}
		cvReleaseMat( &sample );
		cvFree( (void**) &vec.vector );
	}
	fclose( vec.input );
}

int main(int argc, char **argv){
	char *vecname = NULL;
	char *outdir  = NULL;
	int width     = 24;
	int height    = 24;
	int i, j      = 0;

	if( argc == 1 )
	{
		printf( "Usage: %s\n  <input_vec_file_name>\n"
			"  <img_output_dir = %s>\n"
			"  [-w <sample_width = %d>] [-h <sample_height = %d>]\n"
			"Output Files: <img_output_dir>/<input_vec_file_name>_<num>.png",
			argv[0], ".", width, height );
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
		else
		{
			if ( j == 0 )
			{
				vecname = argv[i];
			}
			else
			{
				outdir = argv[i];
			}
			j++;
		}
	}
	if ( vecname == NULL )
	{
		fprintf( stderr, "No input vec file\n" );
		exit(1);
	}
	if ( outdir == NULL )
	{
		outdir = (char *)malloc(sizeof(char) * 2);
		outdir = ".\0";
	}
	icvVec2Img( vecname, outdir, width, height );
	return 0;
}
