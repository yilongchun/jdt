/************************************************************************/
/* copyright(C) 2013-2016 �����׵���ʶ�Ƽ����޹�˾                      */
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
//��ʼ�����ͷ�
STD_API(int)	EXCARDS_Init(const char *szWorkPath);
STD_API(void)	EXCARDS_Done();
STD_API(float)  EXCARDS_GetFocusScore(unsigned char *yimgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);
STD_API(const char*)  EXCARDS_GetVersion();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//���֤ʶ��	���֤ʶ��	���֤ʶ��	���֤ʶ��	���֤ʶ�� BEG 
//����Ƶʶ��ģʽ��//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//���֤ʶ�� szResBuf[ > 4096]
STD_API(int)	EXCARDS_RecoIDCardFile(const char *szImgFile, char *szResBuf, int nResBufSize);
STD_API(int)	EXCARDS_RecoIDCardData(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, char *szResBuf, int nResBufSize);
//////////////////////////////////////////////////////////////////////////
//������ʶ��ĵڶ������ṹ�������������޼����ͼ���������Ҫ����֪�����ַ�ʽ�Ƿ��б�Ҫ����ʱ���������
STD_API(int)	EXCARDS_DecodeIDCardDataStep2(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_DecodeIDCardNV21Step2(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_DecodeIDCardNV12Step2(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, 
											  char *szResBuf, int nResBufSize, int bWantImg, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//���������������һ����ʶ�𲢷��ؽṹ�壬�������޼����ͼ��
STD_API(int)	EXCARDS_RecoIDCardDataST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardFileST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardNV21ST(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardNV12ST(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_FreeIDCardST(EXIDCard *pstIDCard);

//��ͼ��ʶ��ģʽ��//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//����ͼ��ӿڣ��򿪵ľ�ֹͼ��ʶ��ӿ�
//�������GRAY8��BGR24, BGR32��ͼ�� 
STD_API(int)	EXCARDS_RecoIDCardImageST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);
//�Ǳ�׼ͼ��ӿڣ����ñ�׼ͼ��ӿ�, RGBA32λͼ��ʶ�� Android, IOS
STD_API(int)	EXCARDS_RecoIDCardImageRGBA32ST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bWantImg, EXIDCard *pstIDCard);
//�����õĴ��ļ�ʶ�� bomber 2015.5.1
STD_API(int)	EXCARDS_RecoIDCardImageFile(const char *szImgFile, char *pbResult, int nMaxSize);
//ʶ���ļ������ؽṹ�壬ͨEXCARDS_RecoIDCardFileServer 2016.01.22
STD_API(int)	EXCARDS_RecoIDCardImageFileST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
//���ṹ��ת�����ֽ������
STD_API(int)	EXIDCardResToStrInfo(char *szResBuf, const int iBufSize, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//���֤�������汾�ӿ�
//��ͼ��ʶ��ģʽ��////////////////////////////////////////////////////////////////////////
STD_API(int)	EXCARDS_RecoIDCardFileServer(const char *szImgFile, int bWantImg, EXIDCard *pstIDCard);
STD_API(int)	EXCARDS_RecoIDCardDataServer(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXIDCard *pstIDCard);

//////////////////////////////////////////////////////////////////////////
//˫�渴ӡ��һ��A4ֽ�ϣ�ͬʱʶ��
STD_API(int)	EXCARDS_RecoIDCard2FaceFileServerST(const char *szImgFile, int bWantImg, EXIDCard *pstIDCardF, EXIDCard *pstIDCardB);
STD_API(int)	EXCARDS_RecoIDCard2FaceDataServerST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
												    int bWantImg, EXIDCard *pstIDCardF, EXIDCard *pstIDCardB);
STD_API(int)	EXCARDS_RecoIDCard2FaceFileServer(const char *szImgFile, char *szResBuf, int nResBufSize);
STD_API(int)	EXCARDS_RecoIDCard2FaceDataServer(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, 
												  char *szResBuf, int nResBufSize);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//���֤ʶ��	���֤ʶ��	���֤ʶ��	���֤ʶ��	���֤ʶ�� BEG 
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

