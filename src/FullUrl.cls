/**
 * Utility for reading information from a URL
 *
 * scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
 */
public with sharing class FullUrl
{
	private System.URL url;
	private Map<String, String> params;

	public class InvalidUrlException extends Exception { }
	public class MissingParamException extends Exception { }

	public FullUrl(String spec)
	{
		this.setupUrl(spec);

		this.generateParams();
	}

	public FullUrl(String spec, Map<String, String> setParams)
	{
		this.setupUrl(spec);

		this.params = setParams;
	}

	public Integer port()
	{
		return this.url.getDefaultPort();
	}

	public String path()
	{
		return this.url.getPath();
	}

	public String host()
	{
		return this.url.getHost();
	}

	public String query()
	{
		return this.url.getQuery();
	}

	public String fragment()
	{
		return this.url.getRef();
	}

	public List<String> segments()
	{
		List<String> urlSegments = new List<String>();

		for (String segment : this.url.getPath().split('\\/')) {
			if (!String.isBlank(segment)) {
				urlSegments.add(segment);
			}
		}

		return urlSegments;
	}

	public String segment(Integer index)
	{
		return this.returnSegments().get(index);
	}

	public Map<String, String> params()
	{
		return this.params.clone();
	}

	/**
	 * @return String | null
	 */
	public String param(String key)
	{
		return this.params.get(key);
	}

	/**
	 * @return String | defaultValue
	 */
	public String param(String key, String defaultValue)
	{
		String val = this.params.get(key);

		return val == null ? defaultValue : val;
	}

	/**
	 * @return String
	 */
	public override String toString()
	{
		return this.url.toExternalForm();
	}

	private void setupUrl(String spec)
	{
		try {
			this.url = new System.Url(spec);
		} catch(StringException e) {
			throw new InvalidUrlException(e.getMessage());
		}
	}

	private void generateParams()
	{
		this.params = new Map<String, String>();

		if(this.returnQuery() == null) {
			return;
		}

		for(String pair : this.returnQuery().split('&')) {
			integer idx = pair.indexOf('=');
			String key = EncodingUtil.urlDecode(pair.substring(0, idx), 'UTF-8');
			String val = EncodingUtil.urlDecode(pair.substring(idx + 1), 'UTF-8');

			this.params.put(key, val);
		}
	}
}
