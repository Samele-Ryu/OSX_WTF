//
//  MasterViewController.m
//  ScrayBugsMac
//
//  Created by Alexcai on 2016/10/29.
//  Copyright © 2016年 codeMaster. All rights reserved.
//

#import "MasterViewController.h"
#import "ScaryBugsDoc.h"
#import "ScaryBugData.h"
#import "EDStarRating.h"
#import "NSImage+Extras.h"
#import <Quartz/Quartz.h>
#import <webkit/WebView.h>
#import <WebKit/WebFrame.h>
#import <WebKit/WebFrameLoadDelegate.h>


@interface MasterViewController ()<NSTableViewDataSource,NSTableViewDelegate,WebFrameLoadDelegate>
@property (weak) IBOutlet NSTableView *bugsTableView;
@property (weak) IBOutlet NSTextField *bugTitleView;
@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet WebView *webView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeb];
}

- (void)loadWeb {
    WebFrame *webFrames = [self.webView mainFrame];
    NSURL *url = [NSURL URLWithString:@"http://www.iqiyi.com/"];
    [webFrames loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.frameLoadDelegate = self;
}

// 获取选中的数据模型
- (ScaryBugsDoc *)selectedBugDoc{
    NSInteger selectedRow = [self.bugsTableView selectedRow];            // 获取table view 的选中行号
    if (selectedRow >= 0 && self.bugs.count  > selectedRow) {
        ScaryBugsDoc *selectedBug = [self.bugs objectAtIndex:selectedRow];
        return selectedBug;
    }
    return nil;
}
// 这个方法，根据数据设置视图信息
- (void)setDetailInfo:(ScaryBugsDoc *)doc{
    NSString    *title = @"";        // 初始化为空字符串
    NSImage     *image = nil;    // 初始化为空值
    float rating=0.0;                      // 初始化默认值为0
    if( doc != nil ){    // 如果有数据
        title = doc.data.title;
        image = doc.fullImage;
        rating = doc.data.rating;
    }
    [self.bugTitleView setStringValue:title];       // 设置显示的标题
}
// table view 选中一行的时候，会调用这个方法
- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    // 获取选中的数据
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    // 根据数据，设置详情视图内容
    [self setDetailInfo:selectedDoc];
    // Enable/Disable buttons based on selection
    BOOL buttonsEnabled = (selectedDoc!=nil);
    [self.deleteButton setEnabled:buttonsEnabled];
    [self.bugTitleView setEnabled:buttonsEnabled];
}
// 这个方法返回列表的行数 : 类似于iOS中的numberOfRowsInSection:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.bugs.count;
}
// 这个方法返回列表的cell ：参考iOS中的 cellForRowAtIndexPath:
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    // 1.创建可重用的cell:
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    // 2. 根据重用标识，设置cell 数据
    if( [tableColumn.identifier isEqualToString:@"BugColumn"] ){
        ScaryBugsDoc *bugDoc = [self.bugs objectAtIndex:row];
        cellView.imageView.image = bugDoc.thumbImage;
        cellView.textField.stringValue = bugDoc.data.title;
        return cellView;
    }
    return cellView;
}
// 添加新行方法
- (IBAction)addBug:(NSButton *)sender {
    // 1.创建数据模型
    ScaryBugsDoc *newDoc = [[ScaryBugsDoc alloc] initWithTitle:@"New Bug" rating:0.0 thumbImage:nil fullImage:nil];
    // 2. 添加模型到数组中
    [self.bugs addObject:newDoc];
    // 3. 获取添加后的行号
    NSInteger newRowIndex = self.bugs.count - 1;
    // 4. 在table view 中插入新行
    [self.bugsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] withAnimation:NSTableViewAnimationEffectGap];
    // 5. 设置新行选中，并可见
    [self.bugsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:newRowIndex] byExtendingSelection:NO];
    [self.bugsTableView scrollRowToVisible:newRowIndex];
}
// 删除选中的行
- (IBAction)deleteBug:(NSButton *)sender {// 1. Get selected doc
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc ){
        // 1. 从数字中删除数据模型
        [self.bugs removeObject:selectedDoc];
        // 2. table view 删除选中的行
        [self.bugsTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.bugsTableView.selectedRow] withAnimation:NSTableViewAnimationSlideRight];
        // 3. 清空详情视图内容
        [self setDetailInfo:nil];
    }
}
- (IBAction)bugTitleDidEndEdit:(NSTextField *)sender {
     ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if (selectedDoc ){
        // 1. 设置文本
        selectedDoc.data.title = [self.bugTitleView stringValue];
        // 2. 更新行
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedDoc]];
        NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
        [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
    }
}
#pragma mark - EDStarRatingProtocol
-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating
{
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    if( selectedDoc ){
       
    }
}
// 更换图片事件处理
- (IBAction)ChangePicture:(NSButton *)sender {
    ScaryBugsDoc *selectedDoc = [self selectedBugDoc];
    // 当table view 有选中数据时，才可以进行更换图片
    if( selectedDoc ){
        [[IKPictureTaker pictureTaker] beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}
// 图片选择后的回答方法
- (void) pictureTakerDidEnd:(IKPictureTaker *) picker returnCode:(NSInteger) code contextInfo:(void*) contextInfo{
    NSImage *image = [picker outputImage];
    if( image !=nil && (code == NSModalResponseOK) ){
        ScaryBugsDoc * selectedBugDoc = [self selectedBugDoc];
        if( selectedBugDoc ){
            // 1.设置选中的图片
            selectedBugDoc.fullImage = image;
            // 2. 设置缩略图片
            selectedBugDoc.thumbImage = [image imageByScalingAndCroppingForSize:CGSizeMake( 44, 44 )];
            // 3. 获取位置并刷新表格
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:[self.bugs indexOfObject:selectedBugDoc]];
            NSIndexSet * columnSet = [NSIndexSet indexSetWithIndex:0];
            [self.bugsTableView reloadDataForRowIndexes:indexSet columnIndexes:columnSet];
        }
    }
}

#pragma mark webDelegate

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {

}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {

}

















































@end
