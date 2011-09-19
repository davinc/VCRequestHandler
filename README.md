# VCResponseFetcher

A very lightweight HTTP library for processing different types of fetch response.
After receiving every response of the HTTP (GET or POST) request we need to process it depending on the type of the data, say text, image, xml, json etc.
This is a generic library so we can add new custom processors for as many types of different types of responses we need.

All you need to do is get started with predefined processors i.e. 'VCDataResponseProcessor' and 'VCImageResponseProcessor'.

# Usage
Add 'VCResponseFetcher.h' to the header file, and the implementation class should follow 'VCResponseFetchServiceDelegate' protocol, add respective data processor headers to the implementation file and call following method,
<pre>
    [[VCResponseFetcher sharedInstance] addObserver:self
                                                url:url
                                              cache:VCResponseFetchNoCache
                                  responseProcessor:[[[VCDataResponseProcessor alloc] init] autorelease]];
</pre>
