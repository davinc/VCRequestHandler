# VCRequestHandler

A very lightweight library for processing different types of responses.
After receiving every response request we need to process it depending on the type of the data, say text, image, xml, json etc. Using this library, we can put the parsing logic right in the background thread.

## VCRequestHandler
VCRequestHandler maintains operation queue required for network related operations. It also takes care of network activity indicator in the status bar.

## VCRequest
VCRequest is inherited from NSOperation which performs the task of uploading or downloading required data(handles network connection).

## VCDataService
VCDataService provides a service for data related functions such as creating upload data package, header for request, cookies, parsing received data etc.
It consist of VCRequestSource and VCResponseProcessor.

# Usage
Add 'VCRequestHandler.h' to the header file, and the implementation class should follow 'VCRequestDelegate' protocol, add respective data processor headers to the implementation file and call following method,
<pre>
	VCImageService *imageService = [[VCImageService alloc] initWithURL:[NSURL URLWithString:<image link>]];
	VCRequest *request = [VCRequestFactory requestWithObserver:self
												   dataService:imageService];
	[imageService release], imageService = nil;
	[[VCRequestHandler sharedHandler] requestWithRequest:request];
</pre>

Add VCRequestDelegates,
<pre>
-(void)didFinishRequest:(VCRequest *)request
{
// Success
	VCImageService *processor = (VCImageService *)request.dataService;
}

-(void)didFailRequest:(VCRequest *)request
{
// Error
}
</pre>

When removing a view or deallocating a delegate of request, Do not forget to set request delegate to nil.
