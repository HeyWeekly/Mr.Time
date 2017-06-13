//
//  CollectViewController.m
//  Mr.Time
//
//  Created by 王伟伟 on 2017/4/12.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "CollectViewController.h"

@interface HeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong,readwrite) YYLabel *toYearLabel;
@property (nonatomic, strong,readwrite) WWLabel *countLabel;
@property (nonatomic, strong) NSArray *model;
@end


@interface collectCardCell : UITableViewCell
@property (nonatomic, assign) BOOL isUnfold;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *sepLine;
@end

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WWNavigationVC *nav;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation CollectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackGround_Color;
    [self setupViews];
    [self clickExtraLine:self.tableView];
}
- (void)setupViews {
    [self.view addSubview:self.nav];
    [self.view addSubview:self.tableView];
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
        NSArray *act1 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act2 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act3 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。"];
        NSArray *act4 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一",@"何必要在乎别人所说，做你自己活得开心最重要。",@"坚持如一"];
        NSArray *act5 = @[@"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。",@"此刻正在阅读这封信的你身在何方，在做些什么？十五岁的我，怀揣着无法向任何人述说的烦恼的种子，我有话要对十五岁的你说，是否就能将一切诚实地坦露，问问自己到底自己为什么一定要向着某个目的地前行，只要不停的问终能看到答案，狂风巨浪的青春之海虽然很艰难，但是也请将梦想的小舟驶向明天的岸边。只要相信自己的声音前行就可以了，即使是已成为大人的我，也还是会受伤会有睡不着的夜晚，但是，我仍活在苦涩而又甜蜜的这一刻。最后，谢谢你。活在苦涩而又甜蜜的这。"];
        NSMutableDictionary *actHeader = @{@"flag":@"NO",@"act":act1,@"year":@"TO 21 YEARS OLD",@"count":@"3"}.mutableCopy;
        NSMutableDictionary *actHeader2 = @{@"flag":@"NO",@"act":act2,@"year":@"TO 34 YEARS OLD",@"count":@"3"}.mutableCopy;
        NSMutableDictionary *actHeader3 = @{@"flag":@"NO",@"act":act3,@"year":@"TO 25 YEARS OLD",@"count":@"1"}.mutableCopy;
        NSMutableDictionary *actHeader4 = @{@"flag":@"NO",@"act":act4,@"year":@"TO 29 YEARS OLD",@"count":@"5"}.mutableCopy;
        NSMutableDictionary *actHeader5 = @{@"flag":@"NO",@"act":act5,@"year":@"TO 33 YEARS OLD",@"count":@"2"}.mutableCopy;
        NSMutableDictionary *array = @[actHeader,actHeader2,actHeader3,actHeader4,actHeader5].mutableCopy;
        _listArray = array.mutableCopy;
    }
    return _listArray;
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[self.listArray objectAtIndex:section] objectForKey:@"flag"] isEqualToString:@"NO"]) {
        return 0;
    } else {
        return [[[self.listArray objectAtIndex:section] objectForKey:@"act"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    collectCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectCardCell"];
    if (!cell) {
        cell = [[collectCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectCardCell"];
    }
    NSArray *conArr = [[self.listArray objectAtIndex:indexPath.section] objectForKey:@"act"];
    cell.contentLabel.text = conArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100*screenRate;
}
#pragma mark - UITableView Delegate
// 添加头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    HeaderView = self.listArray;
    headView.tag = section;
    
    if (headView.gestureRecognizers == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClickedAction:)];
        [headView addGestureRecognizer:tap];
    }
    
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    // 下面方法更好使
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void) headerViewClickedAction:(UITapGestureRecognizer *)sender {
    if ([[[self.listArray objectAtIndex:sender.view.tag] objectForKey:@"flag"] isEqualToString:@"NO"]) {
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"YES" forKey:@"flag"];
    } else {
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"NO" forKey:@"flag"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.view.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-49)];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        _tableView.sectionHeaderHeight = 63*screenRate;
    }
    return _tableView;
}
- (WWNavigationVC *)nav {
    if (_nav == nil) {
        _nav = [[WWNavigationVC alloc]initWithFrame:CGRectMake(0, 20, KWidth, 44)];
        _nav.backBtn.hidden = YES;
        _nav.navTitle.text = @"收藏";
    }
    return _nav;
}
- (void)clickExtraLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

@implementation collectCardCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    [self.sepLine sizeToFit];
    self.sepLine.left = 20*screenRate;
    self.sepLine.top = 1;
    self.sepLine.height = 0.5;
    self.sepLine.width = KWidth - 40*screenRate;
    [self addSubview:self.sepLine];
    
    [self.contentLabel sizeToFit];
    self.contentLabel.left  = 20*screenRate;
    self.contentLabel.top = self.sepLine.bottom+15*screenRate;
    self.contentLabel.width = KWidth - 40*screenRate;
    [self addSubview:self.contentLabel];
    [self.contentLabel sizeToFit];

}
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = RGBCOLOR(0x39454E);
        _contentLabel.font = [UIFont fontWithName:kFont_SemiBold size:14*screenRate];
        _contentLabel.text = @"别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想，相信我，它一直在你的身边且从未走远。别在20岁就绝口不提你的梦想。";
    }
    return _contentLabel;
}
- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = RGBCOLOR(0xC9D4DD);
    }
    return _sepLine;
}
@end


@implementation HeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifie {
    if (self == [super initWithReuseIdentifier:reuseIdentifie]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    [self.backImage sizeToFit];
    self.backImage.top = 0;
    self.backImage.left = 0;
    self.backImage.width = KWidth;
    self.backImage.height = 63*screenRate;
    [self addSubview:self.backImage];
    
    NSString *str = @"TO 21 YEARS OLD";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    text.yy_color = RGBCOLOR(0x50616E);
    [text yy_setTextHighlightRange:NSMakeRange(3, 2)
                             color:RGBCOLOR(0x15C2FF)
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             NSLog(@"年龄");
                         }];
    self.toYearLabel.attributedText = text;
    [self.toYearLabel sizeToFit];
    self.toYearLabel.left = 20*screenRate;
    self.toYearLabel.top = 15*screenRate;
    [self addSubview:self.toYearLabel];
    
    [self.countLabel sizeToFit];
    self.countLabel.right = KWidth - 20*screenRate;
    self.countLabel.top = 15*screenRate;
    [self addSubview:self.countLabel];
}
- (YYLabel *)toYearLabel {
    if (_toYearLabel == nil) {
        _toYearLabel = [[YYLabel alloc]init];
        _toYearLabel.textColor = RGBCOLOR(0x50616E);
        _toYearLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
        _toYearLabel.numberOfLines = 1;
    }
    return _toYearLabel;
}
- (WWLabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[WWLabel alloc]init];
        NSArray *gradientColors = @[(id)RGBCOLOR(0x15C2FF).CGColor, (id)[UIColor greenColor].CGColor];
        _countLabel.colors =gradientColors;
        _countLabel.text = @"5";
        _countLabel.font = [UIFont fontWithName:kFont_DINAlternate size:24*screenRate];
    }
    return _countLabel;
}
- (UIImageView *)backImage {
    if (_backImage == nil) {
        _backImage = [[UIImageView alloc]init];
        _backImage.image = [UIImage imageNamed:@"ceshi"];
    }
    return _backImage;
}
@end
