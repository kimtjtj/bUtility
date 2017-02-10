// bFindPath.cpp : 콘솔 응용 프로그램에 대한 진입점을 정의합니다.
//

#include "stdafx.h"
#include <vector>

using namespace std;

// 입력 : 현재 좌표, dat 파일, wait 여부
// 출력 : 이동 방향
// 내부 : 목적지 설정(pass 있으면 pass로)
// A* 알고리즘으로 목적지까지의 루틴 탐색
// 목적지로 가는 길이 없으면 dat 파일 초기화
// 다음 이동지가 pass면 pass 삭제
// dat 파일에서 이동방향 삭제

struct structPOSITION
{
	unsigned short int x;
	unsigned short int y;
	
public:
	structPOSITION( ) { x = 0; y = 0; }
	structPOSITION( int i32X, int i32Y )
	{
		x = i32X;
		y = i32Y;
	}
	structPOSITION( structPOSITION& cur, int direction )
	{
		x = cur.x;
		y = cur.y;
		switch( direction )
		{
		case 0:
			x += 1;
			break;
		case 1:
			x -= 1;
			break;
		case 2:
			y += 1;
			break;
		case 3:
			y -= 1;
			break;
		}
	}

	bool IsEmpty( )
	{
		if( 0 == x && 0 == y )
			return true;

		return false;
	}
	bool IsValid( )
	{
		return !IsEmpty( );
	}
};

structPOSITION GetFromDAT( CString wstrDATFile, wchar_t* wstrKey, wchar_t** wstrGoalDirection = NULL );
int FindPath( structPOSITION current, structPOSITION goal, CString wstrDATFile, vector<structPOSITION>* minPath, int i32Gravity = 0 );
int FindPath_NoOpt( structPOSITION current, structPOSITION goal, CString wstrDATFile, vector<structPOSITION>* minPath, int i32Gravity = 0 );
int GetDirection( int i32X, int i32Y, int i32MoveToX, int i32MoveToY );

int main(int argc, char* argv[])
{
	const int i32Parameter = 4;
	int i32Error = 0;
	int i32X = 1, i32Y = 1;
	CString wstrDATFile;
	bool bWait = false;
	structPOSITION pass, goal;
	static vector<structPOSITION> minPath;
	wchar_t *wstrGoalDirection = NULL;

	if( argc < i32Parameter )
	{
		i32Error = -1;
		goto Exit;
	}

	i32X = atoi( argv[ 1 ] );
	i32Y = atoi( argv[ 2 ] );
	wstrDATFile = CString( argv[ 3 ] );

	if( argc > i32Parameter )
	{
		bWait = true;
	}

	wprintf_s( L"i32X : %d\n", i32X );
	wprintf_s( L"i32Y : %d\n", i32Y );
	wprintf_s( L"DATFile : %s\n", wstrDATFile.GetString() );

	pass = GetFromDAT( wstrDATFile, L"Pass" );

	if( pass.IsEmpty( ) )
	{
		goal = GetFromDAT( wstrDATFile, L"Goal", &wstrGoalDirection );
	}
	else
		goal = pass;

	if( i32X == goal.x && i32Y == goal.y && NULL != wstrGoalDirection )
	{
		switch( wstrGoalDirection[ 0 ] )
		{
		case L'R':
			i32Error = 1;
			break;
		case L'L':
			i32Error = 2;
			break;
		case L'D':
			i32Error = 3;
			break;
		case L'U':
			i32Error = 4;
			break;
		}
		goto Exit;
	}

	if( 0 >= FindPath( structPOSITION( i32X, i32Y ), goal, wstrDATFile, &minPath ) )
	{
		FindPath_NoOpt( structPOSITION( i32X, i32Y ), goal, wstrDATFile, &minPath );
	}

	if( 0 == minPath.size( ) )
		i32Error = -1;
	else
		i32Error = GetDirection( i32X, i32Y, minPath[ 0 ].x, minPath[ 0 ].y );

Exit:
	if( bWait )
	{
		for( int i = 0; i < minPath.size( ); ++i )
		{
			wprintf_s( L"pos[%d] : %d, %d\n", i, minPath[ i ].x, minPath[ i ].y );
		}
		wprintf_s( L"i32Error : %d\n", i32Error );
		getc( stdin );
	}

	return i32Error;
}

structPOSITION GetFromDAT( CString wstrDATFile, wchar_t* wstrKey, wchar_t** wstrGoalDirection )
{
	wchar_t strBuffer[ 16 ] = L"";
	GetPrivateProfileString( L"Tile", wstrKey, L"", strBuffer, _countof( strBuffer ), wstrDATFile.GetString( ) );

	if( 0 == wcscmp( strBuffer, L"" ) )
	{
		return structPOSITION( 0, 0 );
	}

	wchar_t* next_token = NULL;
	wchar_t* wstrX = wcstok_s( strBuffer, L"|", &next_token );
	int x = _wtoi( wstrX );

	wchar_t* wstrY = wcstok_s( NULL, L"|", &next_token );
	int y = _wtoi( wstrY );

	if( NULL != wstrGoalDirection )
		*wstrGoalDirection = wcstok_s( NULL, L"|", &next_token );

	return structPOSITION( x, y );
}

int GetOptimal( structPOSITION current, structPOSITION goal, int i32Gravity )
{
	int i32Optimal = i32Gravity;
	i32Optimal += abs( goal.x - current.x );
	i32Optimal += abs( goal.y - current.y );

	return i32Optimal;
}

int FindPath( structPOSITION current, structPOSITION goal, CString wstrDATFile, vector<structPOSITION>* minPath, int i32Gravity )
{
	static vector<structPOSITION> path;

	int ai32Optimal[ 4 ], minOptimal = 0xFFFF;
	CString wstrKey;
	wchar_t wstrBuffer[ 8 ];
	int i32Direction[ 4 ];
	int i = 0, i32Min = -1;

	if( current.x == goal.x && current.y == goal.y )
	{
		if( 0 == minPath->size( ) || minPath->size( ) > path.size( ) )
			*minPath = path;

		return 0;
	}

	wstrKey.Format( L"Tile_%d_%d", current.x, current.y );
	GetPrivateProfileString( L"Tile", wstrKey.GetString( ), L"", wstrBuffer, _countof( wstrBuffer ), wstrDATFile.GetString( ) );
	if( 0 == wcsncmp( wstrBuffer, L"0000", 4 ) || 0 == wcscmp(wstrBuffer, L"") )
		return -1;

	for( i = 0; i < 4; ++i )
	{
		i32Direction[ i ] = wstrBuffer[ i ] - L'0';
		if( 0 == i32Direction[ i ] )
		{
			ai32Optimal[ i ] = 0xffff;
			continue;
		}

		structPOSITION next( current, i );

		ai32Optimal[ i ] = GetOptimal( next, goal, i32Gravity + 1 );
		if( minOptimal > ai32Optimal[ i ] )
			minOptimal = ai32Optimal[ i ];
	}

	for( i = 0; i < 4; ++i )
	{
		if( minOptimal != ai32Optimal[ i ] )
			continue;

		structPOSITION next( current, i );
		bool bFind = false;
		for( auto pos : path )
		{
			if( pos.x == next.x && pos.y == next.y )
			{
				bFind = true;
				break;
			}
		}
		if( bFind )
			continue;

		path.push_back( next );

		FindPath( next, goal, wstrDATFile, minPath, i32Gravity + 1 );
		path.pop_back( );
	}

	return minPath->size( );
}

int FindPath_NoOpt( structPOSITION current, structPOSITION goal, CString wstrDATFile, vector<structPOSITION>* minPath, int i32Gravity )
{
	static vector<structPOSITION> path;

	CString wstrKey;
	wchar_t wstrBuffer[ 8 ];
	int i32Direction[ 4 ];
	int i = 0;

	if( current.x == goal.x && current.y == goal.y )
	{
		if( 0 == minPath->size( ) || minPath->size( ) > path.size( ) )
			*minPath = path;

		return 0;
	}

	wstrKey.Format( L"Tile_%d_%d", current.x, current.y );
	GetPrivateProfileString( L"Tile", wstrKey.GetString( ), L"", wstrBuffer, _countof( wstrBuffer ), wstrDATFile.GetString( ) );
	if( 0 == wcsncmp( wstrBuffer, L"0000", 4 ) || 0 == wcscmp( wstrBuffer, L"" ) )
		return -1;

	for( i = 0; i < 4; ++i )
	{
		i32Direction[ i ] = wstrBuffer[ i ] - L'0';
		if( 0 == i32Direction[ i ] )
			continue;

		structPOSITION next( current, i );
		bool bFind = false;
		for( auto pos : path )
		{
			if( pos.x == next.x && pos.y == next.y )
			{
				bFind = true;
				break;
			}
		}
		if( bFind )
			continue;

		path.push_back( next );

		FindPath_NoOpt( next, goal, wstrDATFile, minPath, i32Gravity + 1 );
		path.pop_back( );
	}

	return minPath->size( );
}

int GetDirection( int i32X, int i32Y, int i32MoveToX, int i32MoveToY )
{
	int i32DiffX = i32MoveToX - i32X;
	int i32DiffY = i32MoveToY - i32Y;

	if( 0 != i32DiffX )
	{
		if( 1 == i32DiffX )
			return 1;

		if( -1 == i32DiffX )
			return 2;
	}

	if( 0 != i32DiffY)
	{
		if( 1 == i32DiffY )
			return 3;

		if( -1 == i32DiffY )
			return 4;
	}

	return 0;
}
