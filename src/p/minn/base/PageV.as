package p.minn.base
{
	import mx.collections.ArrayCollection;

	[RemoteClass(alias="com.page.PageV")]
	public class PageV
	{
		public var pageIndex:int;
		public var pageSize:int;
		public var recordCount:int;
		public var list:ArrayCollection;
		public var condition:ArrayCollection=new ArrayCollection();
		public function PageV()
		{
		}
	}
}