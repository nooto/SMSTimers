//
//  CContactersViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CContactersViewController.h"
#import "RFContact.h"

@interface CContactersViewController ()
-(void)ReadAllPeoples;
@end

@implementation CContactersViewController
@synthesize contactDic, selectContactDic;
@synthesize listTabelView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableDictionary*)contactDic{
	if (contactDic == nil) {
		contactDic = [[NSMutableDictionary alloc]  initWithCapacity:1];
	}
	return contactDic;
}

-(NSMutableArray*)selectContactDic{
	if (selectContactDic == nil) {
		selectContactDic = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return selectContactDic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"添加联系人";
	
	UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
	[left setTintColor:[UIColor blackColor]];
	self.navigationItem.leftBarButtonItem =left;

	
	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction:)];
	[right setTintColor:[UIColor blackColor]];
	self.navigationItem.rightBarButtonItem =right;

	[self ReadAllPeoples];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender{
	if ([self.selectContactDic count] > 0) {
		self.didSelectContacters(selectContactDic);
	}
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)ReadAllPeoples{
	//取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        
		tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
		
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        return ;
    };
	
	NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        RFContact *contact = [[RFContact alloc] init];
		
        //获取的联系人单一属性:First name
        NSString *tmpFirstName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
        tmpFirstName = tmpFirstName==nil ? @"" : tmpFirstName;
        contact.nameFirst = tmpFirstName;
		
        //获取的联系人单一属性:Last name
        NSString *tmpLastName = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty));
        tmpLastName = tmpLastName==nil?@"":tmpLastName;
        contact.nameLast = tmpLastName;
        
		//获取的联系人单一属性:Company name
        NSString *tmpCompanyname = CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty));
        tmpCompanyname = tmpCompanyname==nil?@"":tmpCompanyname;
        contact.company = tmpCompanyname;
      
        
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString *tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            
            tmpPhoneIndex = [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tmpPhoneIndex = [tmpPhoneIndex stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange rang = [tmpPhoneIndex rangeOfString:@"+86"];
            if (rang.length > 0) {
                tmpPhoneIndex =   [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            }
            
            if (tmpPhoneIndex==nil) {
                continue;
            }
            if (![RFUtility isMobileNumber:tmpPhoneIndex]) {
                continue;
            }
            [contact.phoneArray addObject:tmpPhoneIndex];
        }
        CFRelease(tmpPhones);

//        //必须有手机号。
//        if ([contact.phoneArray count] <= 0) {
//            continue;
//        }
//        
//        //非移动号码不显示。
//        NSString *phonenumber= [contact.phoneArray objectAtIndex:0];
//        if ([RFUtility GetMobileType:phonenumber] != MOBILE_CM) {
//            continue;
//        }
        
//        //获取的联系人单一属性:Email(s)
//        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
//        for(NSInteger j = 0; j<ABMultiValueGetCount(tmpEmails); j++)
//        {
//            NSString *tmpEmailIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpEmails, j);
//            if (tmpEmailIndex==nil) {
//                continue;
//            }
//			if (![RFUtility isEmailValid:tmpEmailIndex]) {
//                continue;
//			}
//            [contact.emailArray addObject:tmpEmailIndex];
//        }
//        CFRelease(tmpEmails);
        
        [contact setSortLetter];
        [contact setDisplayName];
		
        if (![contactDic.allKeys containsObject:contact.sortLetter]) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:contact];
            [self.contactDic setObject:array forKey:contact.sortLetter];
        }
		else{
            NSMutableArray *array = [contactDic objectForKey:contact.sortLetter];
            [array addObject:contact];
        }
    }
    //释放内存
    CFRelease(tmpAddressBook);
}
-(NSArray *)arraySort:(NSArray *)array{
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        return [obj1 compare:obj2];
    };
    return [array sortedArrayUsingComparator:sort];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [contactDic.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [[self arraySort:contactDic.allKeys] objectAtIndex:section];
    NSArray *array = [contactDic objectForKey:key];
    return [array count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *array = [self arraySort:contactDic.allKeys];
    return [array objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *sectionTile=[self tableView:tableView titleForHeaderInSection:section];
    if(sectionTile==nil){
        return nil;
    }
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    [headView setBackgroundColor:[RFUtility RGBnsstringToColor:@"229,237,242"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text=sectionTile;
    label.textColor= [RFUtility nsstringToColor:@"#656565"];
    label.font=[RFUtility STHeitiSC:18];
    [headView addSubview:label];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000000000000001;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self arraySort:contactDic.allKeys];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *listContactChoose=@"listContactChoose";
    RFContactCell *cell = (RFContactCell*)[tableView dequeueReusableCellWithIdentifier:listContactChoose];
    if (cell == nil)
    {
        cell = [[RFContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listContactChoose];
    }
    
    NSString *key = [[self arraySort:contactDic.allKeys] objectAtIndex:indexPath.section];
    NSMutableArray *array = [contactDic objectForKey:key];
    RFContact *contact = [array objectAtIndex:indexPath.row];
    if ([self.selectContactDic containsObject:contact]) {
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_on"] forState:UIControlStateNormal];
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_on"] forState:UIControlStateHighlighted];
    }else{
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateNormal];
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateHighlighted];
    }
    cell.displayName.text = contact.displayName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RFContactCell *cell = (RFContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *arrayKey = [self arraySort:contactDic.allKeys];
    NSString *key = [arrayKey objectAtIndex:indexPath.section];
    RFContact *contact = [[contactDic objectForKey:key] objectAtIndex:indexPath.row];
    if ([selectContactDic containsObject:contact]) {
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateNormal];
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateHighlighted];
        [selectContactDic removeObject:contact];
    }else{
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_on"] forState:UIControlStateNormal];
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_on"] forState:UIControlStateHighlighted];
        [selectContactDic addObject:contact];
    }
//    [self performSelector:@selector(cancelBackgound:) withObject:indexPath afterDelay:0.3];
}


@end


@implementation RFContactCell
@synthesize checkButton,displayName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        displayName = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 265, 44)];
        [displayName setBackgroundColor:[UIColor clearColor]];
        [displayName setFont:[UIFont systemFontOfSize:14]];
        [displayName setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:displayName];
        
        checkButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 11, 20, 20)];
        [checkButton setUserInteractionEnabled:NO];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateNormal];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"rf_ic_check_off"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:checkButton];
        
        UIView *v = [[UIView alloc] initWithFrame:self.bounds];
        v.backgroundColor=[RFUtility nsstringToColor:@"#f9fbff"];
        self.backgroundView = v;
        
        UIView *v1= [[UIView alloc] init];
        v1.backgroundColor=[RFUtility nsstringToColor:@"#e1e2e6"];
        self.selectedBackgroundView=v1;
	}
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end

