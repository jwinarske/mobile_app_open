#ifndef EXYNOS_OFI_WRAPPER_H_
#define EXYNOS_OFI_WRAPPER_H_

#include "backend_c.h"
#include "eden_nn_types.h"

NnRet ExynosOFI_Initialize();
NnRet ExynosOFI_OpenModel(EdenModelFile* modelFile, uint32_t* modelId,
                          EdenPreference preference);
NnRet ExynosOFI_OpenEdenModelFromMemory(ModelTypeInMemory modelTypeInMemory,
                                        int8_t* addr, int32_t size,
                                        bool encrypted, uint32_t* modelId,
                                        EdenModelOptions& options);
NnRet ExynosOFI_AllocateInputBuffers(uint32_t modelId, EdenBuffer** buffers,
                                     int32_t* numOfBuffers);
NnRet ExynosOFI_AllocateOutputBuffers(uint32_t modelId, EdenBuffer** buffers,
                                      int32_t* numOfBuffers);
NnRet ExynosOFI_CopyToBuffer(EdenBuffer* buffer, int32_t offset,
                             const char* input, size_t size,
                             IMAGE_FORMAT image_format);
NnRet ExynosOFI_CopyFromBuffer(char* dst, EdenBuffer* buffer, size_t size);
NnRet ExynosOFI_ExecuteModel(EdenRequest* request, addr_t* requestId,
                             EdenPreference preference);
NnRet ExynosOFI_ExecuteEdenModel(EdenRequest* request, addr_t* requestId,
                                 const EdenRequestOptions& options);
NnRet ExynosOFI_GetInputBufferShape(uint32_t modelId, int32_t inputIndex,
                                    int32_t* width, int32_t* height,
                                    int32_t* channel, int32_t* number);
NnRet ExynosOFI_GetOutputBufferShape(uint32_t modelId, int32_t outputIndex,
                                     int32_t* width, int32_t* height,
                                     int32_t* channel, int32_t* number);
NnRet ExynosOFI_FreeBuffers(uint32_t modelId, EdenBuffer* buffers);
NnRet ExynosOFI_CloseModel(uint32_t modelId);
NnRet ExynosOFI_Shutdown(void);

#endif  // EXYNOS_OFI_WRAPPER_H_
