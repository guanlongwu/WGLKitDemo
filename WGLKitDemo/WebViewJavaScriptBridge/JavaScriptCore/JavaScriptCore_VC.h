//
//  JavaScriptCore_VC.h
//  WGLKitDemo
//
//  Created by wugl on 2019/7/13.
//  Copyright © 2019 huya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestJSExport <JSExport>
JSExportAs
(calculateForJS  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)handleFactorialCalculateWithNumber:(NSString *)number
 );
- (void)pushViewController:(NSString *)view title:(NSString *)title;
@end

@interface JavaScriptCore_VC : UIViewController <UIWebViewDelegate, TestJSExport>

@end

NS_ASSUME_NONNULL_END
