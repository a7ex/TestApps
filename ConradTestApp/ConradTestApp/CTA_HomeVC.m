//
//  CTA_HomeVC.m
//  ConradTestApp
//
//  Created by Alex da Franca on 20/10/14.
//  Copyright (c) 2014 farbflash. All rights reserved.
//

#import "CTA_HomeVC.h"

#import "CTA_DetailVC.h"
#import "CTA_DataLoader.h"
#import "CTA_AsyncImageView.h"

#import "UIView+AutoLayoutHelpers.h"

@interface CTA_HomeVC ()

@property (weak, nonatomic) IBOutlet CTA_AsyncImageView *countryImageView;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryDetailLabel;

@property (strong, nonatomic) CTA_DataLoader *dataProvider;
@property (strong, nonatomic) CTA_DataEntity *currentCountry;

@property (assign, nonatomic) BOOL startedPushAnimation;

@end

@implementation CTA_HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CTA_HomeVC *__weak weakSelf = self;
    self.dataProvider = [[CTA_DataLoader alloc] init];
    [self.dataProvider loadJSONFromRemoteURL:[NSURL URLWithString:@"http://www.androidbegin.com/tutorial/jsonparsetutorial.txt"] callback:^(NSArray *result, NSError *error) {
        weakSelf.currentCountry = [weakSelf.dataProvider randomEntity];
        [weakSelf configureViewWithEntity:weakSelf.currentCountry];
    }];
    
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.startedPushAnimation) {
        if (self.currentCountry) {
            self.currentCountry = [self.dataProvider randomEntity];
            [self configureViewWithEntity:self.currentCountry];
            [self setupNavigationBar];
        }
    }
    self.startedPushAnimation = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.startedPushAnimation = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self adjustImageConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)navigateToController
{
    self.startedPushAnimation = YES;
    CTA_DetailVC *vc = (CTA_DetailVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    UIView *v = vc.view; // force IB outlets to load
    [vc setTitle:(self.currentCountry.country)?:@""];
    [vc.detailImageView setImage:self.countryImageView.image];
    vc.currentCountry = self.currentCountry;
    return vc;
}

#pragma mark - setup

- (void)setupNavigationBar
{
    if (!self.currentCountry) {
        [self.navigationItem setTitle:NSLocalizedString(@"Loading data...", @"Loading placeholder text")];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else{
        [self.navigationItem setTitle:NSLocalizedString(@"Overview", @"Overview button label")];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Details", @"Details button label") style:UIBarButtonItemStylePlain target:self action:@selector(detailsButtonTapped:)] animated:YES];
        
    }
}

- (void)configureViewWithEntity:(CTA_DataEntity *)entity
{
    if (entity) {
        [self.countryImageView setImage:nil];
        [self.countryImageView loadImageFromRemoteURL:[NSURL URLWithString:entity.imageURL] callback:^(UIImage *result, NSError *error) {
            if (!error)
                [self adjustImageConstraints];
        }];
        
        [self.countryNameLabel setText:(entity.country)?:@""];
        [self.countryDetailLabel setText:[NSString stringWithFormat:@"%@", (entity.population)?:@""]];
    }
}

- (void)adjustImageConstraints
{
    if (self.countryImageView.image) {
        NSLayoutConstraint *constr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeWidth];
        if (constr) {
            CGFloat imgViewWidth = self.view.frame.size.width - 40;
            constr.constant = imgViewWidth;
            
            constr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeHeight];
            if (constr) {
                CGSize imgSize = self.countryImageView.image.size;
                CGFloat newHeight = MIN(self.view.frame.size.height - 160, (imgSize.height * (imgViewWidth / imgSize.width)));
                constr.constant = newHeight;
                
                NSLayoutConstraint *topConstr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeTop];
                constr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeBottom];
                if (constr) {
                    constr.constant = self.view.frame.size.height - topConstr.constant - 10;
                }
            }
        }
    }
    else{
        
        NSLayoutConstraint *widthConstr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeWidth];
        
        if (widthConstr) {
            
            NSLayoutConstraint *leftConstr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeLeading];
            NSLayoutConstraint *rightConstr = [self.countryImageView ffs_layoutConstraintWithAttribute:NSLayoutAttributeTrailing];
            
            if (leftConstr && rightConstr) {
                
                CGFloat newWidth = self.view.frame.size.width - leftConstr.constant - rightConstr.constant;
                widthConstr.constant = newWidth;
            }
        }
        
    }
    
}

#pragma mark - actions

- (IBAction)detailsButtonTapped:(id)sender
{
    [self.navigationController pushViewController:[self navigateToController] animated:YES];
}

@end
