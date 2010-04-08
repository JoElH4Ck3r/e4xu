/**
 * ...
 * @author wvxvw
 */

package com.nivmusman.uploads;
import php.Lib;

enum Mime
{
	ImageJpeg; //image/jpeg
	ImageGif; //image/gif
	ImagePng; //image/png
	ImageWBmp; //image/vnd.wap.wbmp
	TextPlain; //text/plain
	TextHtml; //text/html
	TextJavaScript; //text/javascript
	TextXml; //text/xml
	ApplicationXml; //application/xml
	ApplicationXGZip; //application/x-gzip
	ApplicationXCompress; //application/x-compress
	ApplicationXNsProxy; //application/x-ns-proxy
	ApplicationXJavaScript; //application/javascript
	ApplicationXTcl; //application/x-tcl
	ApplicationXCsh; //application/x-csh
	ApplicationPostScript; //application/postscript
	ApplicationOctetStream; //application/octet-stream
	ApplicationXCpio; //application/x-cpio
	ApplicationXGtar; //application/x-gtar
	ApplicationXTar; //application/x-tar
	ApplicationXShar; //appliation/x-shar
	ApplicationXZipCompressed; //application/x-zip-compressed
	ApplicationXStuffit; //application/x-stuffit
	ApplicationMacBinHex40; //application/mac-binhex40
	VideoMSVideo; //video/x-msvideo
	VideoQuickTime; //video/quicktime
	VideoMpeg; //video/mpeg
	AudioXWav; //audio/x-wav
	AudioXAiff; //audio/x-aiff
	AudioBasic; //audio/basic
	ApplicationFractals; //application/fractals
	ImageIef; //image/ief
	ImageXMSBmp; //image/x-MS-bmp
	ImageXRgb; //image/x-rgb
	ImageXPortablePixmap; //image/x-portable-pixmap
	ImageXPortableBitmap; //image/x-portable-bitmap
	ImageXPortableAnymap; //image/x-portable-anymap
	ImageXWindowDump; //image/xwindowdump
	ImageXPixmap; //image/x-pixmap
	ImageXBitmap; //image/x-bitmap
	ImageXCmuRaster; //image/x-cmu-raster
	ImageTiff; //image/tiff
	ImageXTexinfo; //application/x-texinfo
	ApplicationXTexinfo; //application/x-dvi
	ApplicationXDvi; //application/x-latex
	ApplicationXTex; //application/x-tex
	ApplicationRtf; //application/rtf
}
/*
application/EDI-X12: EDI X12 data; Defined in RFC 1767
application/EDIFACT: EDI EDIFACT data; Defined in RFC 1767
application/ogg: Ogg, a multimedia bitstream container format; Defined in RFC 5334
application/pdf: Portable Document Format, PDF has been in use for document exchange on the Internet since 1993; Defined in RFC 3778
application/xhtml+xml: XHTML; Defined by RFC 3236
application/xml-dtd: DTD files; Defined by RFC 3023
application/json: JavaScript Object Notation JSON; Defined in RFC 4627
application/zip: ZIP archive files; Registered[6]
Type audio: Audio
audio/mp4: MP4 audio
audio/ogg: Ogg Vorbis, Speex, Flac and other audio; Defined in RFC 5334
audio/vorbis: Vorbis encoded audio; Defined in RFC 5215
audio/x-ms-wma: Windows Media Audio; Documented in Microsoft KB 288102
audio/vnd.rn-realaudio: RealAudio; Documented in RealPlayer Customer Support Answer 2559
audio/vnd.wave: WAV audio; Defined in RFC 2361
Type image
image/svg+xml: SVG vector image; Defined in SVG Tiny 1.2 Specification Appendix M
image/vnd.microsoft.icon: ICO image; Registered[8]
Type message
message/http
Type model: 3D models
Type multipart: Archives and other objects made of more than one part
multipart/mixed: MIME E-mail; Defined in RFC 2045 and RFC 2046
multipart/alternative: MIME E-mail; Defined in RFC 2045 and RFC 2046
multipart/related: MIME E-mail; Defined in RFC 2387 and used by MHTML (HTML mail)
multipart/form-data: MIME Webform; Defined in RFC 2388
multipart/signed: Defined in RFC 1847
multipart/encrypted: Defined in RFC 1847
Type text: Human-readable text and source code
text/css: Cascading Style Sheets; Defined in RFC 2318
text/csv: Comma-separated values; Defined in RFC 4180
text/xml: Extensible Markup Language; Defined in RFC 3023
Type video: Video
video/mp4: MP4 video; Defined in RFC 4337
video/ogg: Ogg Theora or other video (with audio); Defined in RFC 5334
video/x-ms-wmv: Windows Media Video; Documented in Microsoft KB 288102
Type vnd: Vendor Specific Files
application/vnd.oasis.opendocument.text: OpenDocument Text; Registered [10]
application/vnd.oasis.opendocument.spreadsheet: OpenDocument Spreadsheet; Registered [11]
application/vnd.oasis.opendocument.presentation: OpenDocument Presentation; Registered [12]
application/vnd.oasis.opendocument.graphics: OpenDocument Graphics; Registered [13]
application/vnd.ms-excel: Microsoft Excel files
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet: Microsoft Excel 2007 files.
application/vnd.ms-powerpoint: Microsoft Powerpoint files
application/msword: Microsoft Word files
application/vnd.mozilla.xul+xml: Mozilla XUL files
Type x: Non-standard files
application/x-www-form-urlencoded Form Encoded Data; Documented in HTML 4.01 Specification, Section 17.13.4.1
application/x-shockwave-flash: Adobe Flash files; Documented in Adobe TechNote tn_4151 and Adobe TechNote tn_16509
application/x-rar-compressed: RAR archive files
Type x-pkcs: PKCS standard files
application/x-pkcs12: p12 files
application/x-pkcs12: pfx files
application/x-pkcs7-certificates: p7b files
application/x-pkcs7-certificates: spc files
application/x-pkcs7-certreqresp: p7r files
application/x-pkcs7-mime: p7c files
application/x-pkcs7-mime: p7m files
application/x-pkcs7-signature: p7s files
*/
class Uploads 
{
	public static function get(?types:Array<Mime>):Array<FileInfo>
	{
		if (!untyped __call__("isset", __php__("$_FILES"))) return null;
		var parts:Array<String> = 
			untyped __call__("new _hx_array", 
			__call__("array_keys", __php__("$_FILES")));
		var infos:Array<FileInfo> = new Array<FileInfo>();
		var file:Dynamic;
		var info:FileInfo;
		var re:EReg = ~/@/;
		var reSharp:EReg = ~/#/g;
		
		for (part in parts)
		{
			file = untyped __php__("$_FILES[$part]");
			info = new FileInfo(
				reSharp.replace(re.replace(part, "."), "/"), //untyped file['name'], 
				untyped file['type'], 
				untyped file['size'], 
				untyped file['tmp_name'], 
				untyped file['error'], 
				true);
			infos.push(info);
		}
		if (infos.length > 0) return infos;
		else return null;
	}
	
	public static function move(to:String, files:Array<FileInfo>):Void
	{
		var path:String;
		if (!untyped __call__("file_exists", to))
			untyped __call__("mkdir", to, 0777, true);
		for (f in files)
		{
			if (f.status < 1 && f.pending)
			{
				if (untyped __call__("is_uploaded_file", f.tempName))
				{
					path = to + "/" + f.name.substr(0, f.name.lastIndexOf("/"));
					if (!untyped __call__("file_exists", path))
					{
						untyped __call__("mkdir", path, 0777, true);
					}
					untyped __call__("move_uploaded_file", f.tempName, to + "/" + f.name);
				}
			}
		}
	}
}