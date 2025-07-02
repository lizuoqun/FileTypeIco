<template>
  <div class="p-6 max-w-4xl mx-auto">
    <!-- 输入区域 -->
    <div class="flex gap-4 mb-6">
      <el-input v-model="imageUrl" placeholder="请输入图片URL (支持PNG、SVG、ICO格式)" class="flex-1" />
      <el-button type="primary" @click="getImageType" :loading="isLoading" class="whitespace-nowrap">
        获取格式
      </el-button>
    </div>

    <!-- 错误提示 -->
    <el-alert v-if="errorMessage" :message="errorMessage" type="error" show-icon class="mb-6" :closable="false" />

    <!-- 图片预览区域 -->
    <el-card v-if="imageUrl && !errorMessage" class="overflow-hidden transition-all duration-300 hover:shadow-lg">
      <div class="p-6 flex justify-center items-center min-h-[300px]">
        <div v-if="isLoading" class="flex flex-col items-center">
          <el-loading-spinner class="size-16 mb-4" />
          <p class="text-gray-500">加载中...</p>
        </div>
        <div v-else class="max-w-full max-h-[600px]">
          <img :src="imageUrl" :alt="'预览图: ' + imageUrl.split('/').pop()"
            class="max-w-full max-h-[600px] object-contain" @error="handleImageError" />
        </div>
      </div>
      <!-- 图片信息 -->
      <div class="bg-gray-50 px-6 py-3 text-sm text-gray-500 flex justify-between items-center">
        <span>格式: {{ imageType.toUpperCase() }}</span>
        <el-button type="text" size="small" @click="handleSaveImg" class="text-blue-500 hover:text-blue-700">
          <Download class="mr-1 size-14" />
          保存图标
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { IconColumn } from '@renderer/types';
import dayjs from 'dayjs';
import { ElMessage } from 'element-plus'

const ELECTRON_API = (window as any).api

// 响应式变量
const imageUrl = ref('');
const imageType = ref('');
const isLoading = ref(false);
const errorMessage = ref('');


// 获取图片类型
const getImageType = () => {
  const ext = imageUrl.value.split('.').pop()?.toLowerCase() || '';
  imageType.value = ['png', 'svg', 'ico'].includes(ext) ? ext : '';
};



// 处理图片加载失败
const handleImageError = () => {
  errorMessage.value = '图片加载失败，请检查URL是否有效';
};


// 图标数据
const icons = ref<IconColumn[]>([])

// 初始化加载图标数据
const loadIcons = async () => {
  try {
    const data = await ELECTRON_API.loadIcons()
    icons.value = data.length > 0 ? data : []
  } catch (error) {
    console.error('加载图标失败:', error)
  }
}

const handleSaveImg = async () => {
  try {
    await loadIcons()
    const imgData = {
      id: dayjs().format('YYYYMMDDhhmmss'),
      name: imageType.value + '-' + dayjs().format('YYYYMMDDhhmmss'),
      path: imageUrl.value,
      updateTime: dayjs().format('YYYY-MM-DD HH:mm:ss'),
      type: imageType.value
    };
    icons.value.push(imgData)
    // 调用保存方法，使用和 svgPreview.vue 相同的 API
    const success = await ELECTRON_API.saveIcons(JSON.parse(JSON.stringify(icons.value)));
    if (success) {
      ElMessage.success('图片数据保存成功');
    } else {
      ElMessage.error('图片数据保存失败');
    }
  } catch (error) {
    console.error('保存图片数据时出错:', error);
    ElMessage.error('保存图片数据时出错');
  }
};
</script>