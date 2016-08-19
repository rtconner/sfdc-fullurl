# SFDC FullURL Apex Class

URL parser for SF Apex. Useful utility if you need to break a URL into it's parts. 

### Sample Usage
```java
FullUrl url = new FullUrl('https://sandbox.my.salesforce.com/services/apexrest/mypage?foo=bar#here');

System.debug(url.port()); // 443
System.debug(url.host()); // sandbox.my.salesforce.com
System.debug(url.path()); // /services/apexrest/mypage
System.debug(url.param('foo')); // bar
System.debug(url.fragment());  // here
```
