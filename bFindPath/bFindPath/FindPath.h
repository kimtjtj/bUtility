#pragma once

#include "Position.h"
#include "PathNode.h"
#include <vector>
#include <list>

using namespace std;

class CFindPath
{
private:
	CPosition m_Start;
	CPosition m_Goal;

	vector<CPosition> m_vOptimalPath;
	list<CPathNode> m_listPathNode;
	list<CPathNode> m_listClosed;
	CString m_strDATFile;

	int m_i32LastError;

public:
	CFindPath( );
	CFindPath( CPosition& start, CPosition& goal, CString& strDATFile );
	~CFindPath( );

	int FindPath( );

	int GetOptimal( CPosition& start, CPosition& goal, int i32Gravity );
	int GetLastError( );
	CPosition GetNextPosition( );
};

