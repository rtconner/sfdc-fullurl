@isTest
private with sharing class FullUrlTest
{
	@isTest
	public static void cannot_create_invalid_url()
	{
		boolean caught = false;
		try {
			FullUrl url = new FullUrl('/not/a/full-url');
		} catch(FullUrl.InvalidUrlException e) { caught = true; }

		System.assert(caught);
	}

	@isTest
	private static void test_url_methods()
	{
		FullUrl url = new FullUrl('https://sandbox.my.salesforce.com/services/apexrest/application/12345/document-request?blah=hsdfs#extra-stuff');

		System.assertEquals(443, url.port());
		System.assertEquals('sandbox.my.salesforce.com', url.host());
		System.assertEquals('/services/apexrest/application/12345/document-request', url.path());
		System.assertEquals('blah=hsdfs', url.query());
		System.assertEquals('extra-stuff', url.fragment());
	}

	@isTest
	private static void test_segements()
	{
		FullUrl url = new FullUrl('https://sandbox.my.salesforce.com/services/apexrest/application/12345/document-request/9876');

		System.assertEquals(6, url.segments().size());
		System.assertEquals('12345', url.segment(3));
	}

	@isTest
	private static void test_paramters()
	{
		FullUrl url = new FullUrl('https://somedomain.com/something?one=two&foo=bar&complex=%253%20%3E%3C%204)(%20%3F%3F');

		System.assertEquals(3, url.params().size());
		System.assertEquals('bar', url.param('foo'));
		System.assertEquals('%3 >< 4)( ??', url.param('complex'));
	}

	@isTest
	private static void test_missing_paramter()
	{
		FullUrl url = new FullUrl('https://somedomain.com/something?one=two');

		System.assertEquals(null, url.param('missingparamter'));
		System.assertEquals('default value', url.param('missingparamter2', 'default value'));
	}

	@isTest
	private static void test_params_is_empty_with_no_parameters()
	{
		FullUrl url = new FullUrl('https://somedomain.com/something');

		System.assertEquals(null, url.param('missingparamter'));
		System.assertEquals(0, url.params().size());
	}

	@isTest
	private static void test_string_formating()
	{
		String str = 'https://sandbox.my.salesforce.com/services/apexrest/application/12345/document-request?blah=hsdfs#extra-stuff';

		FullUrl url = new FullUrl(str);

		System.assertEquals(str, url.toString());
	}
}
