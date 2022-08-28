//
//  CreditCardOverlayView.h
//  SelvyOCRforCreditCardDemo
//
//  Created by selvas on 2018. 9. 8..
//  Copyright © 2018년 SelvasAI. All rights reserved.
//


#import <UIKit/UIKit.h>

// 사각형 영역 중 한 꼭지점에 대한 좌표 정보
struct AreaPoint {
    int x;
    int y;
};
typedef struct AreaPoint AreaPoint;

// 사각형 영역 중 네 개의 꼭지점에 대한 좌표 정보
struct AreaPoints {
    AreaPoint LT; // Left-Top
    AreaPoint RT; // Right-Top
    AreaPoint RB; // Right-Bottom
    AreaPoint LB; // Left-Bottom
};
typedef struct AreaPoints AreaPoints;

// 기본 한 개 꼭지점 좌표 정보 생성
CG_INLINE AreaPoint
CGAreaPointZero()
{
    AreaPoint p; p.x = 0; p.y = 0; return p;
}

// 꼭지점 한 개 좌표 정보 생성
CG_INLINE AreaPoint
CGAreaPointMake(int x, int y)
{
    AreaPoint p; p.x = x; p.y = y; return p;
}

// 기본 꼭지점 네 개 좌표 정보 생성
CG_INLINE AreaPoints
CGAreaPointsZero() {
    AreaPoints ps; ps.LT = CGAreaPointZero(); ps.RT = CGAreaPointZero(); ps.RB = CGAreaPointZero(); ps.LB = CGAreaPointZero(); return ps;
}

// 꼭지점 네 개 좌표 정보 생성
CG_INLINE AreaPoints
CGAreaPointsMake(AreaPoint LT, AreaPoint RT, AreaPoint RB, AreaPoint LB)
{
    AreaPoints ps; ps.LT = LT; ps.RT = RT; ps.RB = RB; ps.LB = LB; return ps;
}

// 카메라 프리뷰 위에 고정 촬영 영역을 표시해주는 뷰
@interface CreditCardOverlayView : UIView

@property (atomic, assign) AreaPoints points; // 촬영 모드에서 사용되는 신용카드 영역 좌표

- (id)initWithFrame:(CGRect)frame;

@end
