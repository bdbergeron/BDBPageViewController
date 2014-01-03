//
//  BDBPageView.h
//
//  Copyright (c) 2013 Bradley David Bergeron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "BDBPageViewPage.h"


@class BDBPageView;

#pragma mark -
/**
 *  The delegate of a BDBPageView object must adopt the BDBPageViewDelegate protocol. Optional
 *  methods of the protocol allow the delegate to manage selections, configure section headings and
 *  footers, help to delete and reorder cells, and perform other actions.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@protocol BDBPageViewDelegate
<NSObject>

@optional
/**
 *  ---------------------------------------------------------------------------------------
 *  @name Configuring Items for the Page View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Tells the delegate the page view is about to draw a page for a particular item.
 *
 *  @param pageView The BDBPageView object informing the delegate of this impending event.
 *  @param page     A BDBPageViewPage object that pageView is going to use when drawing the item.
 *  @param index    An index locating the item in pageView.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)pageView:(BDBPageView *)pageView willDisplayPage:(BDBPageViewPage *)page forItemAtIndex:(NSUInteger)index;

- (void)pageView:(BDBPageView *)pageView didDisplayPage:(BDBPageViewPage *)page forItemAtIndex:(NSUInteger)index;

- (CGFloat)paddingForPageView:(BDBPageView *)pageView;

@end


#pragma mark -
/**
 *  The BDBPageViewDataSource protocol is adopted by an object that mediates the application's data
 *  model for a UITableView object. The data source provides the table-view object with the
 *  information it needs to construct and modify a table view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@protocol BDBPageViewDataSource
<NSObject>

/**
 *  ---------------------------------------------------------------------------------------
 *  @name Configuring a Page View
 *  ---------------------------------------------------------------------------------------
 */

@required
/**
 *  Asks the data source for a page to insert in a particular location of the page view. (required)
 *
 *  @param pageView The BDBPageView object requesting the page.
 *  @param index    An index locating an item in the page view.
 *
 *  @return An object inheriting from BDBPageViewPage that the page view can use for the specified
 *    item. An assertion is raised if you return nil.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (BDBPageViewPage *)pageView:(BDBPageView *)pageView pageForItemAtIndex:(NSUInteger)index;

/**
 *  Tells the data source to return the number of pages in a page view. (required)
 *
 *  @param pageView The BDBPageView object requesting this information.
 *
 *  @return The number of pages in the page view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (NSUInteger)numberOfPagesInPageView:(BDBPageView *)pageView;

@end


#pragma mark -
/**
 *  An instance of BDBPageView (or simply, a page view) is a means for displaying paged content,
 *  such as in a photo gallery.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@interface BDBPageView : UIView
<UIScrollViewDelegate>

/**
 *  ---------------------------------------------------------------------------------------
 *  @name Delegate and Data Source
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The object that acts as the delegate of the receiving page view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic, weak) id <BDBPageViewDelegate> delegate;

/**
 *  The object that acts as the data source of the receiving page view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic, weak) id <BDBPageViewDataSource> dataSource;


/**
 *  ---------------------------------------------------------------------------------------
 *  @name Configuring a Page View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The background view of the page view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic) UIView *backgroundView;

/**
 *  Returns the number of pages in the page view.
 *
 *  @return The number of pages in the page view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (NSUInteger)numberOfPages;


/**
 *  ---------------------------------------------------------------------------------------
 *  @name Creating Pages
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Registers a class for use in creating new pages.
 *
 *  Prior to dequeueing any pages, call this method or the registerNib:forPageWithReuseIdentifier:
 *  method to tell the page view how to create new pages. If a page of the specified type is not
 *  currently in a reuse queue, the page view uses the provided information to create a new page
 *  object automatically.
 *
 *  If you previously registered a class or nib file with the same reuse identifier, the class you
 *  specify in the pageClass parameter replaces the old entry. You may specify nil for pageClass if
 *  you want to unregister the class from the specified reuse identifier.
 *
 *  @param pageClass  The class of a page that you want to use in the page view.
 *  @param identifier The reuse identifier for the page. This parameter must not be nil and must not
 *    be an empty string.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)registerClass:(Class)pageClass forPageWithReuseIdentifier:(NSString *)identifier;

/**
 *  Registers a nib object containing a page with the page view under a specified identifier.
 *
 *  Prior to dequeueing any pages, call this method or the registerClass:forPageWithReuseIdentifier:
 *  method to tell the page view how to create new pages. If a page of the specified type is not
 *  currently in a reuse queue, the page view uses the provided information to create a new page
 *  object automatically.
 *
 *  If you previously registered a class or nib file with the same reuse identifier, the nib you
 *  specify in the pageNib parameter replaces the old entry. You may specify nil for pageNib if you
 *  want to unregister the nib from the specified reuse identifier.
 *
 *  @param pageNib    A nib object that specifies the nib file to use to create the page. This
 *    parameter cannot be nil.
 *  @param identifier The reuse identifier for the page. This parameter must not be nil and must not
 *    be an empty string.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)registerNib:(UINib *)pageNib forPageWithReuseIdentifier:(NSString *)identifier;

/**
 *  Returns a reusable page object for the specified reuse identifier.
 *
 *  @param identifier A string identifying the page object to be reused. This parameter must not be
 *    nil.
 *  @param index      The index specifying the location of the page. The data source receives this
 *    information when it is asked for the page and should just pass it along. This method uses
 *    the index to perform additional configuration based on the page's position in the page view.
 *
 *  @return A BDBPageViewPage object with the associated reuse identifier. This method always
 *    returns a valid page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (BDBPageViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;


/**
 *  ---------------------------------------------------------------------------------------
 *  @name Reloading the Page View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Reloads the items of the receiver.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)reloadData;


/**
 *  ---------------------------------------------------------------------------------------
 *  @name Accessing Pages
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Returns the index path of the currently visible page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic, readonly) NSUInteger currentPageIndex;

/**
 *  Sets the currently displayed page.
 *
 *  @param index The index of the page to be displayed.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)setCurrentPageIndex:(NSUInteger)index;

/**
 *  Returns the page for the item at the specified index path.
 *
 *  @param index The index locating the item in the receiver.
 *
 *  @return An object representing a page or nil if the page is not visible or index is out of
 *    range.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (BDBPageViewPage *)pageForItemAtIndex:(NSUInteger)index;

/**
 *  Returns an index representing the location of a given page.
 *
 *  @param page A page object of the page view.
 *
 *  @return An index representing the location of the page or nil if the index is invalid.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (NSUInteger)indexForPage:(BDBPageViewPage *)page;


/**
 *  ---------------------------------------------------------------------------------------
 *  @name Navigating Through Pages
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Displays the next page in the currently displayed row.
 *
 *  @param animated Whether or not to animate the transition to the next page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)showNextPageAnimated:(BOOL)animated;

/**
 *  Displays the previous page in the currently displayed row.
 *
 *  @param animated Whether or not to animate the transition to the previous page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (void)showPreviousPageAnimated:(BOOL)animated;

@end
