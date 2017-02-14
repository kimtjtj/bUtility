#pragma once

class CPosition
{
private:
	unsigned short int x;
	unsigned short int y;

public:
	CPosition( );
	CPosition( int i32X, int i32Y );
	CPosition( CPosition& cur, int direction );
	~CPosition( );

	bool operator==( CPosition& right );

	bool IsEmpty( );

	unsigned short int GetX( );
	void SetX( unsigned short int x );
	
	unsigned short int GetY( );
	void SetY( unsigned short int y );
};

