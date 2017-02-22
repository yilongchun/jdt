/************************************************************************/
/* copyright(C) 2013-2016 �����׵���ʶ�Ƽ����޹�˾                      */
/************************************************************************/
#ifndef __EX_DRCARD_RECO_H__
#define __EX_DRCARD_RECO_H__

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////////
typedef struct tagDRCard 
{
	//ֻ��һ��
	char szName[64];     //����
	char szSex[4];		 //�Ա�
	char szNation[16];   //����
	char szCardID[32];   //֤��(���֤��)
	char szAddress[256]; //סַ
	char szBirth[16];    //��������
	char szIssue[64];    //������֤ʱ��
	char szClass[16];    //׼�ݳ���
	char szValid[64];    //��Ч��������
	
	//////////////////////////////////////////////////////////////////////////
	//���¾��������������stdimage������ϵ
	TRect rtName;
	TRect rtSex;
	TRect rtNation;
	TRect rtCardID;
	TRect rtAddress;
	TRect rtBirth;
	TRect rtIssue;
	TRect rtClass;
	TRect rtValid;
	TRect rtFace;	//����ͼ��
	//////////////////////////////////////////////////////////////////////////
	int bValidReco; //�Ƿ���Ч���1 ��Ч��0 ��Ч
	int nConfNum;
	int nUnConfNum;   //����ʶ����Ŷ�
	float fzoom;	  //���ű���
	TBitmap *imCard;  //У����ı�׼ͼ��
	//////////////////////////////////////////////////////////////////////////
}EXDRCard;

//////////////////////////////////////////////////////////////////////////
//�����ݽṹת��Ϊ����
STD_API(int) EXDRCardResToStr(char *szResBuf, const int iBufSize, EXDRCard *pstDRCard);
//�����ݽṹת��Ϊ����
STD_IMPL int EXDRCardResToStrInfo(char *szResBuf, const int iBufSize, EXDRCard *pstDRCard);
//д����ο�����jniʹ��
STD_IMPL int EXDRCardSaveRects(EXDRCard *pstDRCard, int *pRects);
//�ͷ��ڴ�
STD_API(int) EXDRCardFreeST(EXDRCard *pstDRCard);
//��Ƶ��ʶ��///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ʶ��ͼ������BGR32, BGR24, GRAY
STD_API(int) EXDRCardRecoRawDateST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXDRCard *pstDRCard);
//Android��ʽͼ��ʶ��
STD_API(int) EXDRCardRecoNV21ST(unsigned char *pbY, unsigned char *pbVU, int nWidth, int nHeight, int bWantImg, EXDRCard *pstDRCard);
//IOSͼ���ʽʶ��
STD_API(int) EXDRCardRecoNV12ST(unsigned char *pbY, unsigned char *pbUV, int nWidth, int nHeight, int bWantImg, EXDRCard *pstDRCard);
//��ֹͼ��ʶ��///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//�������GRAY8��BGR24, BGR32��ͼ��
STD_API(int) EXDRCardRecoStillImageST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bWantImg, EXDRCard *pstDRCard);
//�Ǳ�׼ͼ��ӿڣ����ñ�׼ͼ��ӿ�,�ڲ���������ת��ת��BGR24
//RGBA32λͼ��ʶ�� Android, IOS
STD_API(int) EXDRCardRecoStillImageRGBA32ST(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bWantImg, EXDRCard *pstDRCard);
//���Խӿڣ��Լ���ͼ�����ʶ��
STD_API(int) EXDRCardRecoImageFileST(const char *szImgFile, int nRecoMode, int bWantImg, EXDRCard *pstDRCard);

#ifdef __cplusplus
}
#endif

#endif //__EX_DRCARD_RECO_H__

