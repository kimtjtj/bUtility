#include "stdafx.h"
#include "Position.h"


CPosition::CPosition( )
{
	x = 0;
	y = 0;
}

CPosition::CPosition( int i32X, int i32Y )
{
	x = i32X;
	y = i32Y;
}

CPosition::CPosition( CPosition & cur, int direction )
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


CPosition::~CPosition( )
{
}

bool CPosition::operator==( CPosition & right )
{
	if( this->x == right.x &&
		this->y == right.y )
		return true;

	return false;
}

bool CPosition::IsEmpty( )
{
	if( 0 == x || 0 == y )
		return true;

	return false;
}

unsigned short int CPosition::GetX( )
{
	return x;
}

void CPosition::SetX( unsigned short int x )
{
	this->x = x;
}

unsigned short int CPosition::GetY( )
{
	return y;
}

void CPosition::SetY( unsigned short int y )
{
	this->y = y;
}
