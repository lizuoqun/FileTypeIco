<template>
    <div class="p-2 pt-0">
        <input type="file" ref="fileInput" multiple accept=".svg" @change="handleFileChange" class="hidden" />
        <el-button type="primary" @click="triggerFileInput">上传 SVG 文件</el-button>

        <el-table :data="uploadedFiles" class="w-full mt-2" stripe border show-overflow-tooltip
            height="calc(100vh - 105px)">
            <el-table-column align="center" width="300">
                <template #header>
                    <div class="flex items-center justify-center">
                        <span>文件名</span>
                        <el-tooltip content="点击文件名可复制" placement="top">
                            <el-icon class="ml-2">
                                <CopyDocument />
                            </el-icon>
                        </el-tooltip>
                    </div>
                </template>
                <template #default="{ row }">
                    <div class="file-name text-center font-bold cursor-pointer" @click="copyToClipboard(row.name)">
                        {{ row.name }}
                    </div>
                </template>
            </el-table-column>
            <el-table-column label="SVG 预览">
                <template #default="{ row }">
                    <div class="svg-preview w-full overflow-auto" v-html="row.content"></div>
                </template>
            </el-table-column>
        </el-table>
    </div>
</template>

<script setup>
import { ElMessage } from 'element-plus'

const fileInput = ref(null)
const uploadedFiles = ref([])

const triggerFileInput = () => {
    fileInput.value.click()
}

const handleFileChange = async (event) => {
    const files = Array.from(event.target.files)

    for (const file of files) {
        if (file.type === 'image/svg+xml') {
            const reader = new FileReader()

            reader.onload = (e) => {
                uploadedFiles.value.push({
                    name: file.name,
                    content: e.target.result
                })
            }
            reader.readAsText(file)
        }
    }
}

const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text).then(() => {
        ElMessage.success('复制成功')
    }).catch((err) => {
        ElMessage.error('复制失败');
        console.error('复制失败', err);
    });
};
</script>
<style>
svg {
    width: 32px;
    height: 32px;
}
</style>