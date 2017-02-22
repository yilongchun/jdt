/************************************************************************/
/* copyright(C) 2013-2016 北京易道博识科技有限公司                      */
/************************************************************************/
#ifndef __EX_DRCARD_RECO_H__
#define __EX_DRCARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////////
typedef struct tagDRCard 
{
	//只有一面
	char szName[64];     //姓名
	char szSex[4];		 //性别
	char szNation[16];   //国籍
	char szCardID[32];   //证号(身份证号)
	char szAddress[256]; //住址
	char szBirth[16];    //出生日期
	char szIssue[64];    //初次领证时间
	char szClass[16];    //准驾车型
	char szValid[64];    //有效期至日期
	
	//////////////////////////////////////////////////////////////////////////
	//以下矩形是相对于整个stdimage的坐标系
	TRect rtName;
	TRect rtSex;
	TRect rtNation;
	TRect rtCardID;
	TRect rtAddress;
	TRect rtBirth;
	TRect rtIssue;
	TRect rtClass;
	TRect rtValid;
	TRect rtFace;	//人脸图像
	//////////////////////////////////////////////////////////////////////////
	int bValidReco; //是否有效结果1 有效，0 无效
	int nConfNum;
	int nUnConfNum;   //整张识别可信度
	float fzoom;	  //缩放比例
	TBitmap *imCard;  //校正后的标准图像
	//////////////////////////////////////////////////////////////////////////
}EXDRCard;

//////////////////////////////////////////////////////////////////////////
//将数据结构转换为明文
STD_API(int) EXDRCardResToStr(char *szResBuf, const int iBufSize, EXDRCard *pstDRCard);
//将数据结构转换为密文
STD_IMPL int EXDRCardResToStrInfo(char *szResBuf, const int iBufSize, EXDRCard *pstDRCard);
//写入矩形框数据jni使用
STD_IMPL int EXDRCardSaveRects(EXDRCard *pstDRCard, int *pRects);
//释放内存
STD_API(int) EXDRCardFreeST(EXDRCard *pstDRCard);
//视频流识别///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//识别图像数据BGR32, BGR24, GRAY
STD_API(int) EXDRCardRecoRawDateST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXDRCard *pstDRCard);
//Android格式图像识别
STD_API(int) EXDRCardRecoNV21ST(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, int bWantImg, EXDRCard *pstDRCard);
//IOS图像格式识别
STD_API(int) EXDRCardRecoNV12ST(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, int bWantImg, EXDRCard *pstDRCard);
//静止图像识别///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//传入的是GRAY8，BGR24, BGR32的图像
STD_API(int) EXDRCardRecoStillImageST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXDRCard *pstDRCard);
//非标准图像接口，调用标准图像接口,内部进行数据转换转成BGR24
//RGBA32位图像识别 Android, IOS
STD_API(int) EXDRCardRecoStillImageRGBA32ST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bWantImg, EXDRCard *pstDRCard);
//调试接口，自己打开图像进行识别
STD_API(int) EXDRCardRecoImageFileST(const char *szImgFile, int nRecoMode, int bWantImg, EXDRCard *pstDRCard);

#ifdef __cplusplus
}
#endif

#endif //__EX_DRCARD_RECO_H__

