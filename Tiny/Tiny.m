/* Tiny.m
 *
 * A tiny Cocoa application which creates a window 
 * and then displays graphics in it.
 * Interface Builder is not used to create this application.
 */

#import <Cocoa/Cocoa.h>         // include the Cocoa Frameworks

/************************************************************
 ** A DemoView instance object of this class draws the image.
 *************************************************************/

@interface DemoView : NSView    // interface of DemoView class
{                               // (subclass of NSView class)
}
- (void)drawRect:(NSRect)rect;  // instance method interface
@end

@implementation DemoView        // implementation of DemoView class

#define X(t) (sin(t)+1) * width * 0.5     // macro for X(t)
#define Y(t) (cos(t)+1) * height * 0.5    // macro for Y(t)

- (void)drawRect:(NSRect)rect   // instance method implementation
{
    double f,g;
    double const pi = 2 * acos(0.0);

    int n = 12;                 // number of sides of the polygon
    /* Get the size of the applications window and view objects */

    float width  = [self bounds].size.width;
    float height = [self bounds].size.height;

    [[NSColor whiteColor] set];   // set the drawing color to white
    NSRectFill([self bounds]);    // fill the view with white

    // The following statements trace two polygons with n sides
    // and connect all of the vertices with lines

    [[NSColor blackColor] set];   // set the drawing color to black

    for (f=0; f<2*pi; f+=2*pi/n) {        // draw the fancy pattern
        for (g=0; g<2*pi; g+=2*pi/n) {
            NSPoint p1 = NSMakePoint(X(f),Y(f));
            NSPoint p2 = NSMakePoint(X(g),Y(g));
            [NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
        }
    }

} // end of drawRect: override method


/* windowWillClose: is a delegate method that gets invoked when
 * the on-screen window is about to close (user clicked close box).
 * In this case, we force the entire application to terminate.
 */

-(void)windowWillClose:(NSNotification *)notification
{
    [NSApp terminate:self];
}

@end  // end of DemoView implementation

/* 
 * setup() performs the functions that would normally be performed by
 * loading a nib file.
 */

void setup()  
{
    NSWindow *myWindow;      // typed pointer to NSWindow object
    NSView   *myView;        // typed pointer to NSView object
    NSRect    graphicsRect;  // contains an origin, width, height

                             // initialize the rectangle variable
    graphicsRect = NSMakeRect(100.0, 350.0, 400.0, 400.0);

    myWindow = [ [NSWindow alloc]              // create the window
               initWithContentRect: graphicsRect
               styleMask:NSTitledWindowMask 
                         |NSClosableWindowMask 
                         |NSMiniaturizableWindowMask
                 backing:NSBackingStoreBuffered
                   defer:NO];

    [myWindow setTitle:@"Tiny Application Window"];

    /* create amd initialize the DemoView instance */
    myView = [ [ [DemoView alloc] initWithFrame:graphicsRect]
autorelease];

    [myWindow setContentView:myView ];   // set windows view

    [myWindow setDelegate:myView ];      // set windows delegate
    [myWindow makeKeyAndOrderFront: nil]; // display window
}

int main()
{
    /* Create the autorelease pool */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    /* Create the application object.       */
    NSApp = [NSApplication sharedApplication];

    /* Set up the window and drawing mechanism */
    setup();

    /* run the main event loop */
    [NSApp run];

    /* We get here when the window is closed. */

    [NSApp release];      /* release the app  */
    [pool release];       /* release the pool */
    return(EXIT_SUCCESS);
}


