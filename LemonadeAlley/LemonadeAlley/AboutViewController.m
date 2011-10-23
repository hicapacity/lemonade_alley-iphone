#import "AboutViewController.h"
#import "PageViewController.h"

@implementation AboutViewController
@synthesize wordpressPageAgent;
@synthesize HUD;

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  wordpressPageAgent = [[WordpressPageAgent alloc] init];
  self.parentViewController.title  = @"About";
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveDataNotification:) 
                                               name:@"PagesUpdateNotification"
                                             object:nil];
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[wordpressPageAgent pages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  NSUInteger row = [indexPath row];
  NSDictionary *page = [[wordpressPageAgent pages] objectAtIndex:row];
  
  NSLog(@"Page: %@", page);
  // Configure the cell...
  cell.textLabel.text = [page objectForKey:@"name"];
  cell.detailTextLabel.text = [page objectForKey:@"url"];
  return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  /*
   DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

- (void) receiveDataNotification:(NSNotification *) notification {
  if ([[notification name] isEqualToString:@"PagesUpdateNotification"]) {
    NSLog (@"Successfully received the Data Update notification!");
    [[self tableView] reloadData];
    [HUD hide:YES];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"Segue identifier: %@", segue.identifier);
  
  if ([[segue identifier] isEqualToString:@"showPage"]) {
    NSLog(@"ShowDetails from prepareforsegue");
    NSInteger row = [[self.tableView indexPathForSelectedRow] row];
    NSDictionary *page = [wordpressPageAgent.pages objectAtIndex:row];
    
    // [segue destinationViewController] is read-only, so in order to
    // write to that view controller you'll have to locally instantiate
    // it here:
    PageViewController *detailViewController = [segue destinationViewController];
    detailViewController.page = page;
    
    // You now have a solid reference to the upcoming / destination view
    // controller. Example use: Allocate and initialize some property of
    // the destination view controller before you reach it and inject a
    // reference to the current view controller into the upcoming one:
    //    upcomingViewController.someProperty = [[SomePropertyClass alloc] initWithString:@"Whatever!"];
    //    upcomingViewController. = [segue sourceViewController];
    
    // Or, equivalent, but more straightforward:
    //upcomingViewController.initialViewController = self;
  }
}


@end
