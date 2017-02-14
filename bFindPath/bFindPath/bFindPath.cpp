// bFindPath.cpp : 콘솔 응용 프로그램에 대한 진입점을 정의합니다.
//

#include "stdafx.h"
#include "FindPath.h"
#include "Position.h"
#include <memory>

// 입력 : 현재 좌표, dat 파일, wait 여부
// 출력 : 이동 방향
// 내부 : 목적지 설정(pass 있으면 pass로)
// A* 알고리즘으로 목적지까지의 루틴 탐색
// 목적지로 가는 길이 없으면 dat 파일 초기화
// 다음 이동지가 pass면 pass 삭제
// dat 파일에서 이동방향 삭제




CPosition GetFromDAT( CString& strDATFile, wchar_t* wstrKey, wchar_t** wstrGoalDirection = NULL );
int GetDirection( int i32X, int i32Y, int i32MoveToX, int i32MoveToY );

int main(int argc, char* argv[])
{
	const int i32Parameter = 4;
	int i32Error = 0;
	int i32X = 1, i32Y = 1;
	CString strDATFile;
	bool bWait = false;
	CPosition pass, goal;
	wchar_t *wstrGoalDirection = NULL;
	unique_ptr<CFindPath> pFindPath;

	if( argc < i32Parameter )
	{
		i32Error = -1;
		goto Exit;
	}

	i32X = atoi( argv[ 1 ] );
	i32Y = atoi( argv[ 2 ] );
	strDATFile = CString( argv[ 3 ] );

	if( argc > i32Parameter )
	{
		bWait = true;
	}

	wprintf_s( L"i32X : %d\n", i32X );
	wprintf_s( L"i32Y : %d\n", i32Y );
	wprintf_s( L"DATFile : %s\n", strDATFile.GetString() );

	pass = GetFromDAT( strDATFile, L"Pass" );

	if( pass.IsEmpty( ) )
	{
		goal = GetFromDAT( strDATFile, L"Goal", &wstrGoalDirection );
	}
	else
		goal = pass;

	if( i32X == goal.GetX() && i32Y == goal.GetY() && NULL != wstrGoalDirection )
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

	pFindPath = make_unique<CFindPath>(CPosition(i32X, i32Y), goal, strDATFile );
	pFindPath->FindPath( );
	if( 0 == pFindPath->GetLastError( ) )
	{
		CPosition next = pFindPath->GetNextPosition( );
		if( true == next.IsEmpty( ) )
		{
			i32Error = -2;
			goto Exit;
		}

		i32Error = GetDirection( i32X, i32Y, next.GetX( ), next.GetY( ) );
	}
Exit:
	if( bWait )
	{
		wprintf_s( L"i32Error : %d\n", i32Error );
		getc( stdin );
	}

	return i32Error;
}

CPosition GetFromDAT( CString& strDATFile, wchar_t* wstrKey, wchar_t** wstrGoalDirection )
{
	wchar_t strBuffer[ 16 ] = L"";
	GetPrivateProfileString( L"Tile", wstrKey, L"", strBuffer, _countof( strBuffer ), strDATFile.GetString( ) );

	if( 0 == wcscmp( strBuffer, L"" ) )
	{
		return CPosition( 0, 0 );
	}

	wchar_t* next_token = NULL;
	wchar_t* wstrX = wcstok_s( strBuffer, L"|", &next_token );
	int x = _wtoi( wstrX );

	wchar_t* wstrY = wcstok_s( NULL, L"|", &next_token );
	int y = _wtoi( wstrY );

	if( NULL != wstrGoalDirection )
		*wstrGoalDirection = wcstok_s( NULL, L"|", &next_token );

	return CPosition( x, y );
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
