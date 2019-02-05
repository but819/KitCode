//
//  ViewController.m
//  BankCardNum
//
//  Created by but-MacBook on 2019/1/29.
//  Copyright © 2019 xxx. All rights reserved.
//

#import "ViewController.h"

#import "UITextField+BankCardInput.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bankCardInput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bankCardInput.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL state = [UITextField bankCardInputTextField:textField
                       shouldChangeCharactersInRange:range
                                   replacementString:string];
    
    return state;
}

@end
