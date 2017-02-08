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

structPOSITION GetFromDAT( CString wstrDATFile, wchar_t* wstrKey );
int FindPath( structPOSITION current, structPOSITION goal, CString wstrDATFile, int i32Gravity = 0 );

int main(int argc, char* argv[])
{
	const int i32Parameter = 4;
	int i32Error = 0;
	int i32X = 1, i32Y = 1;
	CString wstrDATFile;
	bool bWait = false;
	structPOSITION pass, goal;

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
		goal = GetFromDAT( wstrDATFile, L"Goal" );
	else
		goal = pass;

	i32Error = FindPath( structPOSITION( i32X, i32Y ), goal, wstrDATFile );

Exit:
	if( bWait )
		getc( stdin );

	return i32Error;
}

structPOSITION GetFromDAT( CString wstrDATFile, wchar_t* wstrKey )
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

	return structPOSITION( x, y );
}

int GetOptimal( structPOSITION current, structPOSITION goal, int i32Gravity )
{
	int i32Optimal = i32Gravity;
	i32Optimal += abs( goal.x - current.x );
	i32Optimal += abs( goal.y - current.y );

	return i32Optimal;
}

int FindPath( structPOSITION current, structPOSITION goal, CString wstrDATFile, int i32Gravity )
{
	static vector<structPOSITION> path;

	int ai32Optimal[ 4 ], minOptimal = 0xFFFF;
	CString wstrKey;
	wchar_t wstrBuffer[ 8 ];
	int i32Direction[ 4 ];
	int i = 0;

	if( current.x == goal.x && current.y == goal.y )
		return 0;

	wstrKey.Format( L"Tile_%d_%d", current.x, current.y );
	GetPrivateProfileString( L"Tile", wstrKey.GetString(), L"", wstrBuffer, _countof(wstrBuffer), wstrDATFile.GetString( ) );

	for( i = 0; i < 4; ++i )
	{
		i32Direction[i] = wstrBuffer[ i ] - L'0';
		if( 0 == i32Direction[ i ] )
		{
			ai32Optimal[ i ] = 0xffff;
			continue;
		}

		structPOSITION next(current, i);

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

		if( 0 <= FindPath( next, goal, wstrDATFile, i32Gravity + 1 ) )
			return i + 1;

		path.pop_back( );
	}

	return -1;
}
