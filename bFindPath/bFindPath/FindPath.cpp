#include "stdafx.h"
#include "FindPath.h"


CFindPath::CFindPath( )
{
	m_i32LastError = 0;
}

CFindPath::CFindPath( CPosition & start, CPosition & goal, CString & strDATFile )
{
	m_Start = start;
	m_Goal = goal;
	m_strDATFile = strDATFile;
	m_i32LastError = 0;
}


CFindPath::~CFindPath( )
{
}

int CFindPath::FindPath( )
{
	if( true == m_Start.IsEmpty( ) || m_Goal.IsEmpty( ) )
	{
		m_i32LastError = -1;
		return m_i32LastError;
	}

	if( 0 == m_strDATFile.GetLength( ) )
	{
		m_i32LastError = -2;
		return m_i32LastError;
	}

	m_vOptimalPath.clear( );

	if( m_Goal == m_Start )
	{
		m_vOptimalPath.push_back( m_Start );
		m_i32LastError = 0;
		return m_i32LastError;
	}

	vector<CPosition> path;
	path.push_back( m_Start );
	CPathNode pathNode( m_Start, path, GetOptimal( m_Start, m_Goal, 0 ) );
	m_listPathNode.push_back( pathNode );

	while( 0 != m_listPathNode.size() )
	{
		CPathNode currentNode = m_listPathNode.front( );
		m_listPathNode.pop_front( );

		CPosition currentPosition = currentNode.GetCurrent( );
		if( currentPosition == m_Goal )
		{
			m_vOptimalPath = currentNode.GetPath( );
			break;
		}

		CString strKey;
		wchar_t strBuffer[ 16 ];
		strKey.Format( L"Tile_%d_%d", currentPosition.GetX(), currentPosition.GetY() );
		GetPrivateProfileString( L"Tile", strKey.GetString( ), L"", strBuffer, _countof( strBuffer ), m_strDATFile.GetString( ) );
		if( 0 == wcsncmp( strBuffer, L"0000", 4 ) || 0 == wcscmp( strBuffer, L"" ) )
			continue;

		for( int i = 0; i < 4; ++i )
		{
			int i32Direction = strBuffer[ i ] - L'0';

			if( 0 == i32Direction )
			{
				continue;
			}

			CPosition nextPosition( currentPosition, i );

			bool bOptimal = false;
			auto vPath = currentNode.GetPath( );
			vPath.push_back( nextPosition );
			CPathNode next( nextPosition, vPath, GetOptimal( nextPosition, m_Goal, vPath.size() ) );
			int i32Optimal = next.GetOptimal( );

			if( 0 == m_listPathNode.size( ) )
			{
				m_listPathNode.push_back( next );
				continue;
			}

			auto lastNode = m_listPathNode.back( );
			if( lastNode.GetOptimal( ) <= i32Optimal )
			{
				m_listPathNode.push_back( next );
				continue;
			}

			bool bFind = false;
			list<CPathNode>::iterator iterOptimal = m_listPathNode.begin( );

			for( auto i = m_listPathNode.begin( ); i != m_listPathNode.end( ); ++i )
			{
				if( i->GetCurrent( ) == nextPosition )
				{
					bFind = true;
					break;
				}

				if( i->GetOptimal( ) >= i32Optimal && iterOptimal == m_listPathNode.begin() )
				{
					iterOptimal = i;
					continue;
				}
			}

			if( bFind )
				continue;

			m_listPathNode.insert( iterOptimal, next );
		}
	}

	return m_i32LastError;
}

int CFindPath::GetOptimal( CPosition & current, CPosition & goal, int i32Gravity )
{
	int i32XDiff = abs( goal.GetX( ) - current.GetX( ) );
	int i32YDiff = abs( goal.GetY( ) - current.GetY( ) );

	int i32Optimal = i32Gravity;
	i32Optimal += i32XDiff * i32XDiff;
	i32Optimal += i32YDiff * i32YDiff;

	return i32Optimal;
}

int CFindPath::GetLastError( )
{
	return m_i32LastError;
}

CPosition CFindPath::GetNextPosition( )
{
	if( 1 >= m_vOptimalPath.size( ) )
		return CPosition( 0, 0 );

	return m_vOptimalPath[ 1 ];
}
