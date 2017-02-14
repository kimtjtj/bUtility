// bFindPath.cpp : �ܼ� ���� ���α׷��� ���� �������� �����մϴ�.
//

#include "stdafx.h"
#include "FindPath.h"
#include "Position.h"
#include <memory>

// �Է� : ���� ��ǥ, dat ����, wait ����
// ��� : �̵� ����
// ���� : ������ ����(pass ������ pass��)
// A* �˰������� ������������ ��ƾ Ž��
// �������� ���� ���� ������ dat ���� �ʱ�ȭ
// ���� �̵����� pass�� pass ����
// dat ���Ͽ��� �̵����� ����




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
