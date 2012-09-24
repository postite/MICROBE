<?php

class microbe_utils_GD {
	public function __construct(){}
	static function gdInfo() {
		return php_Lib::hashOfAssociativeArray(gd_info());
	}
	static function getImageSize($filename, $imageinfo = null) {
		$types = new _hx_array(array(microbe_utils_ImageType::$GIF, microbe_utils_ImageType::$JPG, microbe_utils_ImageType::$PNG, microbe_utils_ImageType::$SWF, microbe_utils_ImageType::$PSD, microbe_utils_ImageType::$BMP, microbe_utils_ImageType::$TIFF_II, microbe_utils_ImageType::$TIFF_MM, microbe_utils_ImageType::$JPC, microbe_utils_ImageType::$JP2, microbe_utils_ImageType::$JPX, microbe_utils_ImageType::$JB2, microbe_utils_ImageType::$SWC, microbe_utils_ImageType::$IFF, microbe_utils_ImageType::$WBMP, microbe_utils_ImageType::$XBM));
		$a = getimagesize($filename);
		$bits = null;
		$channels = null;
		$mime = null;
		try {
			$bits = microbe_utils_GD_0($a, $bits, $channels, $filename, $imageinfo, $mime, $types);
			$channels = microbe_utils_GD_1($a, $bits, $channels, $filename, $imageinfo, $mime, $types);
			$mime = microbe_utils_GD_2($a, $bits, $channels, $filename, $imageinfo, $mime, $types);
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			$e = $_ex_;
			{
			}
		}
		return _hx_anonymous(array("width" => $a[0], "height" => $a[1], "type" => $types[$a[2]], "bits" => $bits, "channels" => $channels, "mime" => $mime));
	}
	static function image_type_to_extension($imagetype, $include_dot = null) {
		$t = microbe_utils_GD_3($imagetype, $include_dot);
		return microbe_utils_GD_4($imagetype, $include_dot, $t);
	}
	static function imageTypeToMimeType($imagetype) {
		return microbe_utils_GD_5($imagetype);
	}
	static function imageToWBMP($image, $filename = null, $threshold) {
		return image2wbmp($image, $filename, $threshold);
	}
	static function imageAlphaBlending($image, $blendmode) {
		return imagealphablending ($image, $blendmode);
	}
	static function imageAntiAlias($image, $on) {
		return imagealphablending ($image, $on);
	}
	static function imageArc($image, $cx, $cy, $w, $h, $s, $e, $color) {
		return imagearc ($image, $cx, $cy, $w, $h, $s, $e, $color);
	}
	static function imageChar($image, $font, $x, $y, $c, $color) {
		return imagechar($image, $font, $x, $y, $c, $color);
	}
	static function imageCharUp($image, $font, $x, $y, $c, $color) {
		return imagecharup($image, $font, $x, $y, $c, $color);
	}
	static function imageColorAllocate($image, $red, $green, $blue) {
		return imagecolorallocate($image, $red, $green, $blue);
	}
	static function imageColorAllocateAlpha($image, $red, $green, $blue, $alpha) {
		return imagecolorallocatealpha($image, $red, $green, $blue, $alpha);
	}
	static function imageColorAt($image, $x, $y) {
		return imagecolorat($image, $x, $y);
	}
	static function imageColorClosest($image, $red, $green, $blue) {
		return imagecolorclosest($image, $red, $green, $blue);
	}
	static function imageColorClosestAlpha($image, $red, $green, $blue, $alpha) {
		return imagecolorclosestalpha($image, $red, $green, $blue, $alpha);
	}
	static function imageColorDeallocate($image, $color) {
		return imagecolordeallocate($image, $color);
	}
	static function imageColorExact($image, $red, $green, $blue) {
		return imagecolorexact($image, $red, $green, $blue);
	}
	static function imageColorExactAlpha($image, $red, $green, $blue, $alpha) {
		return imagecolorexact($image, $red, $green, $blue, $alpha);
	}
	static function imageColorMatch($image1, $image2) {
		return imagecolormatch($image1, $image2);
	}
	static function imageColorResolve($image, $red, $green, $blue) {
		return imagecolorresolve($image, $red, $green, $blue);
	}
	static function imageColorResolveAlpha($image, $red, $green, $blue, $alpha) {
		return imagecolorresolvealpha($image, $red, $green, $blue, $alpha);
	}
	static function imageColorSet($image, $index, $red, $green, $blue) {
		imagecolorset($image, $index, $red, $green, $blue);
	}
	static function imageColorsForIndex($image, $index) {
		$a = imagecolorsforindex($image, $index);
		$a2 = php_Lib::hashOfAssociativeArray($a);
		return _hx_anonymous(array("red" => $a2->get("red"), "green" => $a2->get("green"), "blue" => $a2->get("blue"), "alpha" => $a2->get("alpha")));
	}
	static function imageColorsTotal($image) {
		return imagecolorstotal($image);
	}
	static function imageColorTransparent($image, $color) {
		return imagecolortransparent($image, $color);
	}
	static function imageConvolution($image, $matrix3x3, $div, $offset) {
		return imageconvolution($image, $matrix3x3, $div, $offset);
	}
	static function imageCopy($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h) {
		return imagecopy($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h);
	}
	static function imageCopyMerge($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct) {
		return imagecopymerge($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct);
	}
	static function imageCopyMergeGray($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct) {
		return imagecopymergegray($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct);
	}
	static function imageCopyResampled($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h) {
		return imagecopyresampled($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h);
	}
	static function imageCopyResized($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h) {
		return imagecopyresized($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h);
	}
	static function imageCreate($x_size, $y_size) {
		$img = imagecreate($x_size, $y_size);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromGif($filename) {
		$img = imagecreatefromgif($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromJpeg($filename) {
		$img = imagecreatefromjpeg($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromPng($filename) {
		$img = imagecreatefrompng($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromString($filename) {
		$img = imagecreatefromstring($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromBmp($filename) {
		$img = imagecreatefromwbmp($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromXbm($filename) {
		$img = imagecreatefromxbm($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateFromXpm($filename) {
		$img = imagecreatefromxpm($filename);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageCreateTrueColor($x_size, $y_size) {
		$img = imagecreatetruecolor($x_size, $y_size);
		return ((Std::is($img, _hx_qtype("Bool"))) ? null : $img);
	}
	static function imageEllipse($image, $cx, $cy, $w, $h, $color) {
		return imageellipse($image, $cx, $cy, $w, $h, $color);
	}
	static function imageFill($image, $x, $y, $color) {
		return imagefill($image, $x, $y, $color);
	}
	static function imageFilledArc($image, $cx, $cy, $w, $h, $s, $e, $color, $style) {
		return imagefilledarc($image, $cx, $cy, $w, $h, $s, $e, $color, $style);
	}
	static function imageFilledEllipse($image, $cx, $cy, $w, $h, $s, $e, $color, $style) {
		return imagefilledellipse($image, $cx, $cy, $w, $h, $color);
	}
	static function imageFilledPolygon($image, $points, $num_points, $color) {
		return imagefilledpolygon($image, $points, $num_points);
	}
	static function imageFilledRectangle($image, $x1, $y1, $x2, $y2, $color) {
		return imagefilledrectangle($image, $x1, $y1, $x2, $y2, $color);
	}
	static function imageFillToBorder($image, $x, $y, $border, $color) {
		return imagefilltoborder($image, $x, $y, $border, $color);
	}
	static function imageFilter($src_im, $filtertype, $arg1 = null, $arg2 = null, $arg3 = null) {
		$filters = new _hx_array(array(microbe_utils_ImageFilter::$NEGATE, microbe_utils_ImageFilter::$GRAYSCALE, microbe_utils_ImageFilter::$BRIGHTNESS, microbe_utils_ImageFilter::$CONTRAST, microbe_utils_ImageFilter::$COLORIZE, microbe_utils_ImageFilter::$EDGEDETECT, microbe_utils_ImageFilter::$EMBOSS, microbe_utils_ImageFilter::$GAUSSIAN_BLUR, microbe_utils_ImageFilter::$SELECTIVE_BLUR, microbe_utils_ImageFilter::$MEAN_REMOVAL, microbe_utils_ImageFilter::$SMOOTH));
		$c = 0;
		{
			$_g = 0;
			while($_g < $filters->length) {
				$i = $filters[$_g];
				++$_g;
				if($i === $filtertype) {
					break;
				}
				$c++;
				unset($i);
			}
		}
		return imagefilter($src_im, $c, $arg1, $arg2, $arg3);
	}
	static function imageFontHeight($font) {
		return imagefontheight($font);
	}
	static function imageFontWidth($font) {
		return imagefontwidth($font);
	}
	static function imageFTBBox($size, $angle, $font_file, $text, $extrainfo = null) {
		return imageftbbox($size, $angle, $font_file, $text, $extrainfo);
	}
	static function imageFTText($image, $size, $angle, $x, $y, $col, $font_file, $text, $extrainfo = null) {
		return imagefttbox($image, $size, $angle, $x, $y, $col, $font_file, $text, $extrainfo);
	}
	static function imageGammaCorrect($image, $inputgamma, $outputgamma) {
		return imagegammacorrect($image, $inputgamma, $outputgamma);
	}
	static function imageGD2($image, $filename = null, $chunk_size = null, $type) {
		return imagegd2($image, $filename, $chunk_size, $type);
	}
	static function imageGD($image, $filename = null) {
		return imagegd($image, $filename);
	}
	static function imageGif($image, $filename = null) {
		return imagegif($image, $filename);
	}
	static function imageInterlace($image, $interlace = null) {
		return imageinterlace($image, $interlace);
	}
	static function imageIsTrueColor($image) {
		return imageistruecolor ($image);
	}
	static function imageJpeg($image, $filename = null, $quality = null) {
		if($quality === null) {
			$quality = 80;
		}
		return imagejpeg($image, $filename, $quality);
	}
	static function imageLayerEffect($image, $effect) {
		$filters = new _hx_array(array(microbe_utils_ImageLayerEffect::$REPLACE, microbe_utils_ImageLayerEffect::$NORMAL, microbe_utils_ImageLayerEffect::$OVERLAY));
		$c = 0;
		{
			$_g = 0;
			while($_g < $filters->length) {
				$i = $filters[$_g];
				++$_g;
				if($i === $effect) {
					break;
				}
				$c++;
				unset($i);
			}
		}
		return imagelayereffect($image, $c);
	}
	static function imageLine($image, $x1, $y1, $x2, $y2, $color) {
		return imageline($image, $x1, $y1, $x2, $y2, $color);
	}
	static function imageLoadFont($file) {
		return imageloadfont($file);
	}
	static function imagePaletteCopy($destination, $source) {
		imagepalettecopy($destination, $source);
	}
	static function imagePng($image, $filename = null) {
		return imagepng($image, $filename);
	}
	static function imagePolygon($image, $points, $num_points, $color) {
		return imagepolygon($image, $points, $num_points, $color);
	}
	static function imagePSBBox($text, $font, $size, $space = null, $tightness = null, $angle) {
		return imagepsbbox($text, $font, $size, $space, $tightness, $angle);
	}
	static function imagePSEncodeFont($font_index, $encodingfile) {
		return imagepsencodefont($font_index, $encodingfile);
	}
	static function imagePSExtendFont($font_index, $extend) {
		return imagepsextendfont($font_index, $extend);
	}
	static function imagePSFreeFont($fontindex) {
		return imagepsfreefont($fontindex);
	}
	static function imagePSLoadFont($filename) {
		return imagepsloadfont($filename);
	}
	static function imagePSSlantFont($font_index, $slant) {
		return imagepsslantfont($font_index, $slant);
	}
	static function imagePSText($image, $text, $font, $size, $foreground, $background, $x, $y, $space = null, $tightness = null, $angle = null, $antialias_steps = null) {
		return imagepstext($image, $text, $font, $size, $foreground, $background, $x, $y, $space, $tightness, $angle, $antialias_steps);
	}
	static function imageRectangle($image, $x1, $y1, $x2, $y2, $col) {
		return imagerectangle($image, $x1, $y1, $x2, $y2, $col);
	}
	static function imageRotate($src_im, $angle, $bgd_color, $ignore_transparent = null) {
		return imagerotate($src_im, $angle, $bgd_color, $ignore_transparent);
	}
	static function imageSaveAlpha($image, $saveflag) {
		return imagesavealpha ($image, $saveflag);
	}
	static function imageSetBrush($image, $brush) {
		return imageSetBrush($image, $brush);
	}
	static function imageSetPixel($image, $x, $y, $color) {
		return imagesetpixel($image, $x, $y, $color);
	}
	static function imageSetStyle($image, $style) {
		return imagesetstyle($image, $style);
	}
	static function imageSetThickness($image, $thickness) {
		return imagesetthickness($image, $thickness);
	}
	static function imageSetTile($image, $tile) {
		return imagesettile($image, $tile);
	}
	static function imageString($image, $font, $x, $y, $s, $col) {
		return imagestring($image, $font, $x, $y, $s, $col);
	}
	static function imageStringUp($image, $font, $x, $y, $s, $col) {
		return imagestringup($image, $font, $x, $y, $s, $col);
	}
	static function imageSX($image) {
		return imagesx($image);
	}
	static function imageSY($image) {
		return imagesy($image);
	}
	static function imageTrueColorToPalette($image, $dither, $ncolors) {
		return imagetruecolortopalette($image, $dither, $ncolors);
	}
	static function imageTTFBBox($size, $angle, $fontfile, $text) {
		return imagettfbbox($size, $angle, $fontfile, $text);
	}
	static function imageTTFText($image, $size, $angle, $x, $y, $color, $fontfile, $text) {
		return imagettftext($image, $size, $angle, $x, $y, $color, $fontfile, $text);
	}
	static function imageTypes() {
		return imagetypes();
	}
	static function imageWBmp($image, $filename = null, $foreground = null) {
		return imagewbmp($image, $filename, $foreground);
	}
	static function imageXbm($image, $filename = null, $foreground = null) {
		return imagexbm($image, $filename, $foreground);
	}
	static function iptcEmbed($iptcdata, $jpeg_file_name, $spool = null) {
		return iptcembed($iptcdata, $jpeg_file_name, $spool);
	}
	static function iptcParse($iptcblock) {
		return iptcparse($iptcblock);
	}
	static function jpeg2wbmp($jpegname, $wbmpname, $d_height, $d_width, $threshold) {
		return jpeg2wbmp($jpegname, $wbmpname, $d_height, $d_width, $threshold);
	}
	static function png2wbmp($pngname, $wbmpname, $d_height, $d_width, $threshold) {
		return png2wbmp($pngname, $wbmpname, $d_height, $d_width, $threshold);
	}
	function __toString() { return 'microbe.utils.GD'; }
}
function microbe_utils_GD_0(&$a, &$bits, &$channels, &$filename, &$imageinfo, &$mime, &$types) {
	if($a[4] !== null) {
		return $a[4];
	}
}
function microbe_utils_GD_1(&$a, &$bits, &$channels, &$filename, &$imageinfo, &$mime, &$types) {
	if($a[5] !== null) {
		return $a[5];
	}
}
function microbe_utils_GD_2(&$a, &$bits, &$channels, &$filename, &$imageinfo, &$mime, &$types) {
	if($a[6] !== null) {
		return $a[6];
	}
}
function microbe_utils_GD_3(&$imagetype, &$include_dot) {
	$»t = ($imagetype);
	switch($»t->index) {
	case 0:
	{
		return "gif";
	}break;
	case 1:
	{
		return "jpg";
	}break;
	case 2:
	{
		return "png";
	}break;
	case 3:
	{
		return "swf";
	}break;
	case 4:
	{
		return "psd";
	}break;
	case 5:
	{
		return "bmp";
	}break;
	case 6:
	{
		return "tiff";
	}break;
	case 7:
	{
		return "tiff";
	}break;
	case 8:
	{
		return "jpc";
	}break;
	case 9:
	{
		return "jp2";
	}break;
	case 10:
	{
		return "jpf";
	}break;
	case 11:
	{
		return "jb2";
	}break;
	case 12:
	{
		return "swc";
	}break;
	case 13:
	{
		return "aiff";
	}break;
	case 14:
	{
		return "wbmp";
	}break;
	case 15:
	{
		return "xbm";
	}break;
	}
}
function microbe_utils_GD_4(&$imagetype, &$include_dot, &$t) {
	if($include_dot) {
		return "." . $t;
	} else {
		return $t;
	}
}
function microbe_utils_GD_5(&$imagetype) {
	$»t = ($imagetype);
	switch($»t->index) {
	case 0:
	{
		return "image/gif";
	}break;
	case 1:
	{
		return "image/jpeg";
	}break;
	case 2:
	{
		return "image/png";
	}break;
	case 3:
	{
		return "application/x-shockwave-flash";
	}break;
	case 4:
	{
		return "image/psd";
	}break;
	case 5:
	{
		return "image/psd";
	}break;
	case 6:
	{
		return "image/tiff";
	}break;
	case 7:
	{
		return "image/tiff";
	}break;
	case 8:
	{
		return "image/octet-stream";
	}break;
	case 9:
	{
		return "image/jp2";
	}break;
	case 10:
	{
		return "image/octet-stream";
	}break;
	case 11:
	{
		return "image/octet-stream";
	}break;
	case 12:
	{
		return "image/x-shockwave-flash";
	}break;
	case 13:
	{
		return "image/iff";
	}break;
	case 14:
	{
		return "image/vnd.wap.wbmp";
	}break;
	case 15:
	{
		return "image/xbm";
	}break;
	}
}
