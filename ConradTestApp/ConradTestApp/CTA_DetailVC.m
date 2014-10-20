//
//  CTA_DetailVC.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_DetailVC.h"

#import "UIView+AutoLayoutHelpers.h"

@interface CTA_DetailVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation CTA_DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureTextWithEntity:self.currentCountry];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self adjustScrollViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupView
{
    self.backButton.layer.cornerRadius = 6;
    self.backButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.backButton.layer.shadowOpacity = 0.7;
    self.backButton.layer.shadowOffset = CGSizeMake(1, 1);
    
}

- (void)configureTextWithEntity:(CTA_DataEntity *)entity
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:[self headlineForEntity:entity]];
    if (entity) {
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\r"]];
        [attrString appendAttributedString:[self bodyForEntity:entity]];
    }
    
    [self.textLabel setAttributedText:attrString];
}

- (void)adjustScrollViewConstraints
{
    NSLayoutConstraint *heightConstr;
    NSLayoutConstraint *topConstr;
    
    NSLayoutConstraint *widthConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeWidth];
    
    if (widthConstr) {
        
        CGFloat margin = (self.view.frame.size.width - widthConstr.constant) / 2.0;
        
        NSLayoutConstraint *leftConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeLeading];
        NSLayoutConstraint *rightConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeTrailing];
        
        if (leftConstr && rightConstr) {
            leftConstr.constant = floorf(margin);
            rightConstr.constant = leftConstr.constant;
        }
    }
    
    NSLayoutConstraint *bottomConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeBottom];
    heightConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeHeight];
    topConstr = [self.backButton ffs_layoutConstraintWithAttribute:NSLayoutAttributeTop];
    if (bottomConstr) {
        bottomConstr.constant = self.view.frame.size.height - [self currentTopBarHeight] - ((heightConstr)?heightConstr.constant:0.0) - ((topConstr)?topConstr.constant:20.0);
    }
    
    
    CGFloat headlineHeight = 50.0;
    CGFloat textWidth = 280.0;

    
    CGRect textBounds = [[self.textLabel attributedText] boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil];
    
    heightConstr = [self.textLabel ffs_layoutConstraintWithAttribute:NSLayoutAttributeHeight];
    
    if (heightConstr)
        heightConstr.constant = textBounds.size.height;
    
    topConstr = [self.textLabel ffs_layoutConstraintWithAttribute:NSLayoutAttributeTop];
    
    if (topConstr) {
        CGFloat topInset = self.view.frame.size.height - headlineHeight - [self currentTopBarHeight];
        topConstr.constant = topInset;
    }
    
}

- (CGFloat)currentTopBarHeight
{
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGFloat statusBarHeight = MIN(statusBarSize.height, statusBarSize.width);
    return navBarHeight + statusBarHeight;
}

#pragma mark - actions

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scrollview delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        CGFloat scrollOffs = scrollView.contentOffset.y + [self currentTopBarHeight];
        CGFloat level = MAX(0.5, MIN(1.0, (1 - (scrollOffs / self.view.frame.size.height))));
        [self.detailImageView setAlpha:level];
    }
}

#pragma mark - text formatting

- (NSAttributedString *)headlineForEntity:(CTA_DataEntity *)entity
{
    NSString *headline = (entity)?entity.country:NSLocalizedString(@"No countries found.", @"No data message");
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.paragraphSpacing = 40;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1.0, 1.0)];
    [shadow setShadowBlurRadius:5.0];
    [shadow setShadowColor:[UIColor blackColor]];
    
    return [[NSAttributedString alloc] initWithString:headline
                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:27.0],
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
                                                        NSParagraphStyleAttributeName:paragraphStyle,
                                                        NSShadowAttributeName:shadow}];
}

- (NSAttributedString *)bodyForEntity:(CTA_DataEntity *)entity
{
    if (!entity)
        return [[NSAttributedString alloc] initWithString:@""];
    
    NSString *body = [NSString stringWithFormat:@"%@: %@\r%@: %ld",
                      NSLocalizedString(@"Population", @"Body label: population"), (entity.population)?:@"",
                      NSLocalizedString(@"Rank", @"Body label: rank"), (long)entity.rank];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    return [[NSAttributedString alloc] initWithString:body
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
                                                        NSParagraphStyleAttributeName:paragraphStyle}];
}


@end
