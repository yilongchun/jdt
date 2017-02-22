/************************************************************************/
/* copyright(C) 2013-2016 北京易道博识科技有限公司                      */
/************************************************************************/
#ifndef __GR_BITMAP_H__
#define __GR_BITMAP_H__

#ifdef __cplusplus
extern "C" 
{
#endif

//YUV图像格式定义
#define IMG_FMT_NV21	0x0001		//NV21 Android
#define IMG_FMT_NV12	0x0002		//NV12 IOS

/* pixel mode constants */
typedef enum TPixelMode_
{
    gr_pixel_mode_none = 0,
	gr_pixel_mode_mono,        /* monochrome bitmaps               */
	gr_pixel_mode_gray,        /* 8-bit gray levels                */
	gr_pixel_mode_rgb24,       /* 24-bits mode - 16 million colors */
	gr_pixel_mode_rgb32,       /* 32-bits mode - 16 million colors */
	gr_pixel_mode_max          /* don't remove */
}TPixelMode;

/* 颜色 bgra32 */
typedef union TColor_
{
    unsigned int   value;     //0xargb little endian
    unsigned char  chroma[4]; //bgra
}TColor;

/*********************************************************************
*
* <Struct>
*   grBitmap
*
* <Description>
*   a simple bitmap descriptor
*
* <Fields>
*   rows   :: height in pixels
*   width  :: width in pixels
*   pitch  :: + or - the number of bytes per row
*   mode   :: pixel mode of bitmap buffer
*   grays  :: number of grays in palette for PAL8 mode. 0 otherwise
*   buffer :: pointer to pixel buffer
*
* <Note>
*   the 'pitch' is positive for downward flows, and negative otherwise
*   Its absolute value is always the number of bytes taken by each
*   bitmap row.
*
*   All drawing operations will be performed within the first
*   "width" pixels of each row (clipping is always performed).
*
********************************************************************/
typedef struct TBitmap_
{
    int             height;
    int             width;
    int             pitch;
    TPixelMode      mode;
    int             grays;
	int				xdpi;
	int				ydpi;
    unsigned char*  buffer;
}TBitmap;

//////////////////////////////////////////////////////////////////////////
TPixelMode	grBitCount2PixelMode(int nBitCount);
int			grPixelMode2BitCount(TPixelMode pm);

TBitmap	   *grCreateBitmap(TPixelMode pixel_mode, int num_grays, int width, int height);
void		grDoneBitmap(TBitmap** ppbit );

TBitmap	   *grCreateBitmapHead(TPixelMode pixel_mode, int num_grays, int width, int height);
void		grDoneBitmapHead(TBitmap** ppbit);

int			grCreateBitmapData(TBitmap *bit);
void		grDoneBitmapData(TBitmap *bit);

int			grInitBitmapHead(TPixelMode pixel_mode, int num_grays, int width, int height, TBitmap *bit);
void		grEmptyBitmap(TBitmap*  bit, TColor colorbk);
void		grEmptyBitmapWithVal(TBitmap*  bit, unsigned char val);
TColor		grFindColor( TBitmap*  target, int red, int green, int  blue, int alpha );

void		grFillRect(TBitmap* target, int x, int y, int width, int height, TColor color );
void		grFillHLine(TBitmap* target, int x, int y, int width, TColor color );
void		grFillVLine(TBitmap* target, int x, int y, int height,TColor color );
int			grBitmapCopyTo(TBitmap *pSrcImg, TBitmap *pDstImg);
void		grDrawRect(TBitmap* target, int x, int y, int width, int height, TColor color );

int			grConvertGray(TBitmap *pImgClc, TBitmap *pImgGry);
int			grRGBAConvertGray(TBitmap *pImgClc, TBitmap *pImgGry);
int			grBinConvertGray(TBitmap *pImgBin, TBitmap *pImgGry);
int			grBinConvertBGR(TBitmap *pImgBin, TBitmap *pImgClc);
TBitmap	   *grRaw2Bitmap(int nBitCount, unsigned char *pImg, int nImgW, int nImgH);

int			grBitmapInvert(TBitmap *pstImg); //反色
int			grFilpTopBtm(TBitmap *pstBitmap);  //上下翻转

unsigned char *grBitmapFirstLine(TBitmap *pBitmap);
unsigned char *grBitmapLinePtr(TBitmap *pBitmap, int nLine);

TBitmap	   *grBitmapClone(TBitmap *pstBitmap);
int			grBitmapSetPixel(TBitmap *pstBitmap, int x, int y, int val);
int			grSetPixelLow(unsigned char *line, int x, int mode, int val);
int			grBitmapGetPixel(TBitmap *pstBitmap, int x, int y);
int			grGetPixelLow(unsigned char *line, int x, int mode);
int		    grGetHistgram(TBitmap *pImgGry, int *naHist);
int			grDrawLine(TBitmap *bitmap, int x1, int y1, int x2, int y2, TColor color);
int			grFillPoints(TBitmap *pImgClc, TPoint *pPoints, int nPointNum, TColor color);
/* 将指针重新指向大图中的一个小图 */
int			grMakeSubImageLite(TBitmap *pLarge, TBitmap *pSub, int lft, int top, int rgt, int btm);
//////////////////////////////////////////////////////////////////////////
//#define __ZIMAGE_IO__

int		 grSave2Bitmap(TBitmap *pbitmap, const char *szFilePath);
int		 grSave2Bitmap2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, const char *szFilePath);
TBitmap	*grLoadImage(const char *szFilePath);
int		 grFDebugImage(TBitmap *bitmap, char *lpszFormat, ...);

//////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
}
#endif

#endif //#endif