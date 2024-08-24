//
//  ViewController.h
//  SQLClientDemo
//
//  Created by Venkata Subba Raju Ganapathiraju on 23/08/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *serverInstanceName;
@property (weak, nonatomic) IBOutlet UITextField *dbName;

@property (weak, nonatomic) IBOutlet UITextField *tableName;

@property (weak, nonatomic) IBOutlet UIButton *db_connect;

@property (weak, nonatomic) IBOutlet UIButton *table_query;

- (IBAction)serverInstanceChanged:(UITextField *)sender;

- (IBAction)dbNameChanged:(UITextField *)sender;

- (IBAction)tableNameChanged:(UITextField *)sender;

- (IBAction)testDBConnection:(UIButton *)sender;

- (IBAction)executeQuery:(UIButton *)sender;

@end

