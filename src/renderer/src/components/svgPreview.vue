<template>
    <div class="p-2">
        <input type="file" ref="fileInput" multiple accept=".svg" @change="handleFileChange" class="hidden" />
        <el-button type="primary" @click="triggerFileInput">上传 SVG 文件</el-button>
        <div class="preview-container flex flex-wrap gap-5 mt-5">
            <div v-for="(file, index) in uploadedFiles" :key="index"
                class="file-item border border-gray-300 p-2 rounded-md w-52">
                <div class="file-name text-center mb-2 font-bold">{{ file.name }}</div>
                <div class="svg-preview w-full h-40 overflow-auto" v-html="file.content"></div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElButton } from 'element-plus'

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
</script>
