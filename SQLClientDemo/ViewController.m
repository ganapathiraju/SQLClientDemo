//
//  ViewController.m
//  SQLClientDemo
//
//  Created by Venkata Subba Raju Ganapathiraju on 23/08/24.
//

#import "ViewController.h"
#import "SQLClient.h"

@interface ViewController ()
@property (nonatomic, strong) UITextField *dbInstanceField;
@property (nonatomic, strong) UITextField *dbNameField;
@property (nonatomic, strong) UITextField *dbUserName;
@property (nonatomic, strong) UITextField *dbUserPassword;
@property (nonatomic, strong) UITextField *tableNameField;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *countButton;

@end

@implementation ViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(error:) name:SQLClientErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:SQLClientMessageNotification object:nil];
}

- (void)setupUI {
    // Setup dbInstanceField
    self.dbInstanceField = [[UITextField alloc] init];
    self.dbInstanceField.placeholder = @"Enter DB Instance";
    self.dbInstanceField.borderStyle = UITextBorderStyleRoundedRect;
    self.dbInstanceField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dbInstanceField];
    
    // Setup dbNameField
    self.dbNameField = [[UITextField alloc] init];
    self.dbNameField.placeholder = @"Enter Database Name";
    self.dbNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.dbNameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dbNameField];
    
    // Setup Username
    self.dbUserName = [[UITextField alloc] init];
    self.dbUserName.placeholder = @"Enter User Name";
    self.dbUserName.borderStyle = UITextBorderStyleRoundedRect;
    self.dbUserName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dbUserName];
    
    // Setup Password
    self.dbUserPassword = [[UITextField alloc] init];
    self.dbUserPassword.placeholder = @"Enter Password";
    self.dbUserPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.dbUserPassword.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.dbUserPassword];
    
    // Setup tableNameField
    self.tableNameField = [[UITextField alloc] init];
    self.tableNameField.placeholder = @"Enter Table Name";
    self.tableNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.tableNameField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableNameField];
    
    // Setup connectButton
    self.connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    self.connectButton.backgroundColor = [UIColor systemBlueColor];
    [self.connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.connectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.connectButton addTarget:self action:@selector(connectToDatabase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectButton];
    
    // Setup countButton
    self.countButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.countButton setTitle:@"Count Rows" forState:UIControlStateNormal];
    self.countButton.backgroundColor = [UIColor systemGreenColor];
    [self.countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.countButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.countButton addTarget:self action:@selector(countTableRows) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.countButton];
    
    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.dbInstanceField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.dbInstanceField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.dbInstanceField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.dbNameField.topAnchor constraintEqualToAnchor:self.dbInstanceField.bottomAnchor constant:20],
        [self.dbNameField.leadingAnchor constraintEqualToAnchor:self.dbInstanceField.leadingAnchor],
        [self.dbNameField.trailingAnchor constraintEqualToAnchor:self.dbInstanceField.trailingAnchor],
        
        [self.dbUserName.topAnchor constraintEqualToAnchor:self.dbNameField.bottomAnchor constant:20],
        [self.dbUserName.leadingAnchor constraintEqualToAnchor:self.dbNameField.leadingAnchor],
        [self.dbUserName.trailingAnchor constraintEqualToAnchor:self.dbNameField.trailingAnchor],
        
        [self.dbUserPassword.topAnchor constraintEqualToAnchor:self.dbUserName.bottomAnchor constant:20],
        [self.dbUserPassword.leadingAnchor constraintEqualToAnchor:self.dbNameField.leadingAnchor],
        [self.dbUserPassword.trailingAnchor constraintEqualToAnchor:self.dbNameField.trailingAnchor],
        
        [self.connectButton.topAnchor constraintEqualToAnchor:self.dbUserPassword.bottomAnchor constant:20],
        [self.connectButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.tableNameField.topAnchor constraintEqualToAnchor:self.connectButton.bottomAnchor constant:20],
        [self.tableNameField.leadingAnchor constraintEqualToAnchor:self.dbNameField.leadingAnchor],
        [self.tableNameField.trailingAnchor constraintEqualToAnchor:self.dbNameField.trailingAnchor],
        
        [self.countButton.topAnchor constraintEqualToAnchor:self.tableNameField.bottomAnchor constant:20],
        [self.countButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];
}

- (void)connectToDatabase {
    NSString *dbInstance = self.dbInstanceField.text;
    NSString *dbName = self.dbNameField.text;
    NSString *dbUserName = self.dbUserName.text;
    NSString *dbPassword = self.dbUserPassword.text;
    
    if (dbInstance.length == 0 || dbName.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Please enter DB Instance and Database Name"];
        return;
    }
    
    SQLClient *client = [SQLClient sharedInstance];
    [client connect:dbInstance username:dbUserName password:dbPassword database:dbName completion:^(BOOL success) {
        if (success) {
            [self showAlertWithTitle:@"Success" message:[NSString stringWithFormat:@"Connected to %@", dbName]];
        } else {
            [self showAlertWithTitle:@"Error" message:@"Connection failed"];
        }
    }];
}

- (void)countTableRows {
    NSString *tableName = self.tableNameField.text;
    
    if (tableName.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Please enter Table Name"];
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
    
    SQLClient *client = [SQLClient sharedInstance];
    [client execute:query completion:^(NSArray *results) {
        if (results.count > 0) {
            NSDictionary *row = results.firstObject;
            NSNumber *count = row.allValues.firstObject;
            [self showAlertWithTitle:@"Row Count" message:[NSString stringWithFormat:@"Number of rows: %@", count]];
        } else {
            [self showAlertWithTitle:@"Error" message:@"Failed to retrieve row count"];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - SQLClientErrorNotification

- (void)error:(NSNotification*)notification
{
    NSNumber* code = notification.userInfo[SQLClientCodeKey];
    NSString* message = notification.userInfo[SQLClientMessageKey];
    NSNumber* severity = notification.userInfo[SQLClientSeverityKey];
    
    NSLog(@"Error #%@: %@ (Severity %@)", code, message, severity);
    [self showAlertWithTitle:@"Error" message:message];
}

#pragma mark - SQLClientMessageNotification

- (void)message:(NSNotification*)notification
{
    NSString* message = notification.userInfo[SQLClientMessageKey];
    NSLog(@"Message: %@", message);
}


@end
