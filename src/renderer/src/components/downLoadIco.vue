<template>
  <div class="p-6 max-w-4xl mx-auto">
    <!-- 输入区域 -->
    <div class="flex gap-4 mb-6">
      <el-input
        v-model="imageUrl"
        placeholder="请输入图片URL (支持PNG、SVG、ICO格式)"
        class="flex-1"
        :prefix-icon="Search"
        @keyup.enter="loadImage"
      />
      <el-button
        type="primary"
        @click="loadImage"
        :loading="isLoading"
        class="whitespace-nowrap"
      >
        加载图片
      </el-button>
    </div>

    <!-- 错误提示 -->
    <el-alert
      v-if="errorMessage"
      :message="errorMessage"
      type="error"
      show-icon
      class="mb-6"
      :closable="false"
    />

    <!-- 图片预览区域 -->
    <el-card v-if="imageUrl && !errorMessage"
      class="overflow-hidden transition-all duration-300 hover:shadow-lg"
    >
      <div class="p-6 flex justify-center items-center min-h-[300px]">
        <div v-if="isLoading" class="flex flex-col items-center">
          <el-loading-spinner class="size-16 mb-4" />
          <p class="text-gray-500">加载中...</p>
        </div>
        <div v-else class="max-w-full max-h-[600px]">
          <!-- SVG格式使用v-html渲染 -->
          <div
            v-if="imageType === 'svg'"
            class="svg-preview max-w-full max-h-[600px]"
            v-html="svgContent"
          ></div>
          <!-- PNG/ICO格式使用img标签 -->
          <img
            v-else
            :src="imageUrl"
            :alt="'预览图: ' + imageUrl.split('/').pop()"
            class="max-w-full max-h-[600px] object-contain"
            @error="handleImageError"
          />
        </div>
      </div>
      <!-- 图片信息 -->
      <div class="bg-gray-50 px-6 py-3 text-sm text-gray-500 flex justify-between items-center">
        <span>格式: {{ imageType.toUpperCase() }}</span>
        <el-button
          type="text"
          size="small"
          @click="copyImageUrl"
          class="text-blue-500 hover:text-blue-700"
        >
          <CopyDocument class="mr-1 size-14" /> 复制URL
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import axios from 'axios';
import {ElMessage} from 'element-plus'

// 响应式变量
const imageUrl = ref('');
const imageType = ref('');
const svgContent = ref('');
const isLoading = ref(false);
const errorMessage = ref('');

// 验证URL格式
const isValidImageUrl = (url) => {
  const regex = /\.(png|svg|ico)$/i;
  return regex.test(url);
};

// 获取图片类型
const getImageType = (url) => {
  const ext = url.split('.').pop().toLowerCase();
  return ['png', 'svg', 'ico'].includes(ext) ? ext : '';
};

// 加载图片
const loadImage = async () => {
  if (!imageUrl.value.trim()) {
    errorMessage.value = '请输入有效的图片URL';
    return;
  }

  if (!isValidImageUrl(imageUrl.value)) {
    errorMessage.value = 'URL必须以.png、.svg或.ico结尾';
    return;
  }

  isLoading.value = true;
  errorMessage.value = '';
  imageType.value = getImageType(imageUrl.value);
  svgContent.value = '';

  try {
    // 对于SVG，我们需要获取其内容以使用v-html渲染
    if (imageType.value === 'svg') {
      const response = await axios.get(imageUrl.value);
      svgContent.value = response.data;
    }
  } catch (err) {
    errorMessage.value = `加载失败: ${err.message}`;
    console.error('图片加载失败:', err);
  } finally {
    isLoading.value = false;
  }
};

// 处理图片加载失败
const handleImageError = () => {
  errorMessage.value = '图片加载失败，请检查URL是否有效';
};

// 复制图片URL到剪贴板
const copyImageUrl = () => {
  navigator.clipboard.writeText(imageUrl.value)
    .then(() => {
      ElMessage.success('URL已复制到剪贴板');
    })
    .catch(() => {
      ElMessage.error('复制失败，请手动复制');
    });
};

// 组件挂载时检查是否需要引入ElMessage
onMounted(() => {
  // 确保Element Plus的ElMessage可用
  if (typeof ElMessage === 'undefined') {
    console.warn('请确保Element Plus的ElMessage已正确引入');
  }
});
</script>