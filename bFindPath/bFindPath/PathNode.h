#pragma once

#include "Position.h"
#include <vector>
using namespace std;

class CPathNode
{
private:
	CPosition m_Current;
	vector<CPosition> m_vPath;
	int m_i32Optimal;

public:
	CPathNode( );
	CPathNode( CPosition& current, vector<CPosition>& path, int i32Optimal );
	//CPathNode( CPosition& current, int i32Optimal );
	~CPathNode( );

	CPosition& GetCurrent( );
	vector<CPosition>& GetPath( );
	int GetOptimal( );
};

