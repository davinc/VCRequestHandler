# VCRequestHandler

A very lightweight HTTP library for processing different types of fetch response.
After receiving every response of the HTTP (GET or POST) request we need to process it depending on the type of the data, say text, image, xml, json etc.
This is a generic library so we can add new custom processors for as many types of different types of responses we need.

All you need to do is get started with predefined processors i.e. 'VCResponseProcessor' and 'VCImageResponseProcessor'.

# Usage
Add 'VCRequestHandler.h' to the header file, and the implementation class should follow 'VCRequestDelegate' protocol, add respective data processor headers to the implementation file and call following method,
<pre>
    [[VCRequestHandler sharedHandler] requestWithObserver:self
                                                      url:url
                                                    cache:VCResponseFetchNoCache
                                        responseProcessor:[[[CustomResponseProcessor alloc] init] autorelease]];
</pre>

When removing a view or deallocating a delegate of request, Do not forget to set request delegate to nil.