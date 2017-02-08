// bMapToTile.cpp : 콘솔 응용 프로그램에 대한 진입점을 정의합니다.
//

#include "stdafx.h"
#include <memory>

int ConvertTXTToDat(CString &strTXTFile, int i32Width, int i32Height );

int main(int argc, char* argv[])
{
	int i32Exit = 0;
	CString strTXTFile = argv[ 1 ];
	int i32Width = 0;
	int i32Height = 0;

	const int PARAMETER = 4;

	if( argc < PARAMETER )
	{
		i32Exit = -1;
		goto Label_Exit;
	}

	for( int i = 0; i < argc; ++i )
	{
		wprintf_s( L"%S\n", argv[ i ] );
	}
	
	i32Width = atoi( argv[ 2 ] );
	i32Height = atoi( argv[ 3 ] );

	i32Exit = ConvertTXTToDat( strTXTFile , i32Width, i32Height);

Label_Exit:
	wprintf_s( L"argc : %d, Result : %d\n", argc, i32Exit );
	getc( stdin );
	return i32Exit;;
}


int ConvertTXTToDat( CString &strTXTFile, int i32Width, int i32Height )
{
	CFile file;
	BOOL bResult = file.Open( strTXTFile, CFile::modeReadWrite );
	if( 0 == bResult )
	{
		wchar_t wstrCurDir[ MAX_PATH ];
		GetCurrentDirectory( MAX_PATH, wstrCurDir );
		wprintf_s( L"CurDir : %s, FileName : %s\n", wstrCurDir, strTXTFile.GetString( ) );
		return -2;
	}

	std::unique_ptr<wchar_t> strDATFile( new wchar_t[ strTXTFile.GetLength() + 1 ] );
	wcscpy_s( strDATFile.get( ), strTXTFile.GetLength( ) + 1, strTXTFile.GetString( ) );
	PathRemoveExtension( strDATFile.get() );
	PathAddExtension( strDATFile.get( ), L".dat" );

	CFile fileDAT;
	bResult = fileDAT.Open( strDATFile.get(), CFile::modeCreate | CFile::modeWrite );
	if( 0 == bResult )
	{
		wchar_t wstrCurDir[ MAX_PATH ];
		GetCurrentDirectory( MAX_PATH, wstrCurDir );
		wprintf_s( L"CurDir : %s, FileName : %s, error : %d\n", wstrCurDir, strDATFile.get(), GetLastError() );
		return -3;
	}

	int i32Length = (int)file.GetLength( );
	std::unique_ptr<char> strBuffer( new char[ i32Length + 1 ] );

	file.Read( strBuffer.get(), i32Length );
	strBuffer.get()[ i32Length ] = '\0';

	CString str = CString( strBuffer.get() );
	strBuffer.get( )[ 0 ] = '\0';
	
	fileDAT.Write( "[Tile]\n", strlen("[Tile]\n") );

	int i32Y = 1;
	int i32X = 1;
	for( int i = 0; i < str.GetLength( ); ++i )
	{
		wchar_t wstrCurrent = str.GetAt( i );
		switch( wstrCurrent )
		{
		case L'─':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1100\n", i32X, i32Y );
			break;
		case L'│':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 0011\n", i32X, i32Y );
			break;
		case L'┌':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1010\n", i32X, i32Y );
			break;
		case L'┐':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 0110\n", i32X, i32Y );
			break;
		case L'┘':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 0101\n", i32X, i32Y );
			break;
		case L'└':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1001\n", i32X, i32Y );
			break;
		case L'├':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1011\n", i32X, i32Y );
			break;
		case L'┬':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1110\n", i32X, i32Y );
			break;
		case L'┤':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 0111\n", i32X, i32Y );
			break;
		case L'┴':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1101\n", i32X, i32Y );
			break;
		case L'┼':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Tile_%d_%d = 1111\n", i32X, i32Y );
			break;
		case L'U':
		case L'L':
		case L'D':
		case L'R':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Goal = %d|%d|%c\n", i32X, i32Y, wstrCurrent );
			break;
		case 'P':
			sprintf_s( strBuffer.get( ), i32Length + 1, "Pass = %d|%d\n", i32X, i32Y );
			break;
		case L'\t':
			++i32X;
			break;
		case L'\n':
			i32X = 1;
			++i32Y;
			break;
		}

		if( 0 < strlen( strBuffer.get( ) ) )
		{
			fileDAT.Write( strBuffer.get( ), strlen( strBuffer.get( ) ) );
		}
		strBuffer.get( )[ 0 ] = '\0';
	}

	return 0;
}
