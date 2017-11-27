//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Dragota Mircea on 27/11/2017.
//  Copyright © 2017 Dragota Mircea. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController


-(NSMutableAttributedString *)historyText {
    if(!_historyText) {
        _historyText = [[NSMutableAttributedString alloc] init];
    }
    return _historyText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!([self.historyText length] == 0)){
        self.historyTextView.attributedText = self.historyText;
    }else {
         self.historyTextView.attributedText = [[NSMutableAttributedString alloc] initWithString:@"You didn't start the game"];
    }
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
