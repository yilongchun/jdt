/************************************************************************/
/* copyright(C) 2013-2016 北京易道博识科技有限公司                      */
/************************************************************************/
#ifndef __EX_CARDS_H__
#define __EX_CARDS_H__

#include "commondef.h"
#include "grbitmap.h"
#include "exidcard.h"
#include "exdrcard.h"

#ifdef __cplusplus
extern "C"{
#endif

//////////////////////////////////////////////////////////////////////////
//初始化和释放
STD_API(int)	EXCARDS_Init(const char *szWorkPath);
STD_API(void)	EXCARDS_Done();
STD_API(float)  EXCARDS_GetFocusScore(unsigned char *yimgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);
STD_API(const char*)  EXCARDS_GetVersion();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//身份证识别	身份证识别	身份证识别	身份证识别	身份证识别 BEG 
//【视频识别模式】//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//身份证识别 szResBuf[ > 4096]
STD_API(int)	EXCARDS_RecoIDCardFile(const char *szImgFile, char *szResBuf, int nResBufSize);
STD_API(int)	EXCARDS_RecoIDCardData(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, char *szResBuf, int nResBufSize);
//////////////////////////////////////////////////////////////////////////
//分两步识别的第二步，结构解析，并返回修剪后的图像，如果有需要【不知道这种方式是否有必要，暂时保留在这里】
STD_API(int)	EXCARDS_DecodeIDCardDataStep2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_DecodeIDCardNV21Step2(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_DecodeIDCardNV12Step2(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//将上面的两步并成一步，识别并返回结构体，并返回修剪后的图像
STD_API(int)	EXCARDS_RecoIDCardDataST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardFileST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardNV21ST(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardNV12ST(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_FreeIDCardST(EXIDCard *pstIDCard);

//【图像识别模式】//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//新增图像接口，打开的静止图像识别接口
//传入的是GRAY8，BGR24, BGR32的图像 
STD_API(int)	EXCARDS_RecoIDCardImageST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);
//非标准图像接口，调用标准图像接口, RGBA32位图像识别 Android, IOS
STD_API(int)	EXCARDS_RecoIDCardImageRGBA32ST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bWantImg, EXIDCard *pstIDCard);
//测试用的打开文件识别 bomber 2015.5.1
STD_API(int)	EXCARDS_RecoIDCardImageFile(const char *szImgFile, char *pbResult, int nMaxSize);
//识别文件，返回结构体，通EXCARDS_RecoIDCardFileServer 2016.01.22
STD_API(int)	EXCARDS_RecoIDCardImageFileST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
//将结构体转换成字节流输出
STD_API(int)	EXIDCardResToStrInfo(char *szResBuf, const int iBufSize, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//身份证服务器版本接口
//【图像识别模式】////////////////////////////////////////////////////////////////////////
STD_API(int)	EXCARDS_RecoIDCardFileServer(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardDataServer(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//双面复印在一张A4纸上，同时识别
STD_API(int)	EXCARDS_RecoIDCard2FaceFileServerST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCardF, EXIDCard *pstIDCardB);
STD_API(int)	EXCARDS_RecoIDCard2FaceDataServerST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
												    int bWantImg, EXIDCard *pstIDCardF, EXIDCard *pstIDCardB);
STD_API(int)	EXCARDS_RecoIDCard2FaceFileServer(const char *szImgFile, char *szResBuf, int nResBufSize);
STD_API(int)	EXCARDS_RecoIDCard2FaceDataServer(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
												  char *szResBuf, int nResBufSize);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//身份证识别	身份证识别	身份证识别	身份证识别	身份证识别 BEG 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**************************************************************************************************************************************************/

STD_API(int)	Convert2BGRA(TBitmap *bitmap, unsigned char *pbImage, int width, int height, int stride);
STD_API(int)	Convert2RGBA(TBitmap *bitmap, unsigned char *pbImage, int width, int height, int stride);
STD_API(int)	Convert2AGBR(TBitmap *bitmap, unsigned char *pbImage, int width, int height, int stride);
STD_API(int)	EXIDCARDSaveRects(EXIDCard *pstIDCard, int *pRects);

#ifdef __cplusplus
}
#endif

#endif

