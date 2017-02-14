#include "stdafx.h"
#include "PathNode.h"


CPathNode::CPathNode( )
{
}

CPathNode::CPathNode( CPosition & current, vector<CPosition>& path, int i32Optimal )
{
	this->m_Current = current;
	this->m_vPath = path;
	this->m_i32Optimal = i32Optimal;
}

//CPathNode::CPathNode( CPosition & current, int i32Optimal )
//{
//	this->m_Current = current;
//	this->m_i32Optimal = i32Optimal;
//}

CPathNode::~CPathNode( )
{
}

CPosition & CPathNode::GetCurrent( )
{
	return m_Current;
}

vector<CPosition>& CPathNode::GetPath( )
{
	return m_vPath;
}

int CPathNode::GetOptimal( )
{
	return m_i32Optimal;
}
