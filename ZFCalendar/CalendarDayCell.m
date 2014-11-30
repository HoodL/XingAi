//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//


#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, self.bounds.size.width-10, self.bounds.size.width-10)];
    imgview.image = [UIImage imageNamed:@"历史记录-日历选中小圆"];
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];
    day_lab.textColor=[UIColor blackColor];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    //[self addSubview:day_title];
    

}


- (void)setModel:(CalendarDayModel *)model
{

    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            //[self hidden_NO];

            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            if (model.holiday) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            }
            
            day_lab.textColor = [UIColor lightGrayColor];
            day_lab.textColor=[UIColor blackColor];

            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
                day_lab.textColor=[UIColor blackColor];

            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
                day_lab.textColor = COLOR_THEME;
                day_lab.textColor=[UIColor blackColor];

            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
                day_lab.textColor=[UIColor blackColor];

            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
                day_lab.textColor = COLOR_THEME1;
                day_lab.textColor=[UIColor blackColor];

            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            day_lab.textColor=[UIColor blackColor];

            imgview.hidden = NO;
            
            break;
        case CellDayExistData:
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            day_lab.textColor=[UIColor blackColor];
            
            imgview.hidden = NO;
            break;
        case CellDayNoData:
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            day_lab.textColor=[UIColor blackColor];
            
            imgview.hidden = YES;
            break;
        default:
            
            break;
    }


}



- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}


@end
