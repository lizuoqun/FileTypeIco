<template>
    <div class="p-2 pt-0">
        <input type="file" ref="fileInput" multiple accept=".svg" @change="handleFileChange" class="hidden" />
        <el-button type="primary" @click="triggerFileInput">上传 SVG 文件</el-button>
        <el-button type="success" @click="showInputDialog">输入 SVG 代码</el-button>

        <el-dialog v-model="dialogVisible" title="输入 SVG 代码">
            <el-form :model="form" label-width="100px">
                <el-form-item label="文件名称">
                    <el-input v-model="form.name" placeholder="请输入文件名称（可选）"></el-input>
                </el-form-item>
                <el-form-item label="SVG 代码">
                    <el-input v-model="form.content" type="textarea" :rows="10" placeholder="请输入 SVG 代码"></el-input>
                </el-form-item>
                <el-form-item label="备注">
                    <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注（可选）"></el-input>
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="dialogVisible = false">取消</el-button>
                    <el-button type="primary" @click="addSvgFromCode">确定</el-button>
                </span>
            </template>
        </el-dialog>

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
            <el-table-column label="操作" width="160" align="center">
                <template #default="scope">
                    <el-button text plain @click="handleSave(scope.row)">保存</el-button>
                </template>
            </el-table-column>
        </el-table>
    </div>
</template>

<script setup lang="ts">
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs';
import { fileColumn, IconColumn } from '@renderer/types';

const ELECTRON_API = (window as any).api

const fileInput = ref(null)
const uploadedFiles = ref<fileColumn[]>([])
const dialogVisible = ref(false)
const form = reactive<fileColumn>({
    name: '',
    content: '',
    remark: ''
})

const triggerFileInput = () => {
    if (fileInput.value) {
        (fileInput.value as HTMLInputElement).click()
    }
}

const handleFileChange = async (event) => {
    const files = Array.from(event.target.files)

    for (const file of files) {
        if ((file as File).type === 'image/svg+xml') {
            const reader = new FileReader()

            reader.onload = (e) => {
                uploadedFiles.value.push({
                    name: (file as File).name,
                    content: typeof e.target?.result === 'string' ? e.target.result : ''
                })
            }
            reader.readAsText(file as File)
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

const showInputDialog = () => {
    dialogVisible.value = true
    form.content = ''
    form.name = ''
}

const addSvgFromCode = () => {
    const { content, name, remark } = form
    if (content.trim()) {
        let fileName = name.trim() + '.svg' || `custom-${dayjs().format('YYYYMMDDHHmmss')}.svg`
        uploadedFiles.value.push({
            name: fileName,
            content,
            remark
        })
        dialogVisible.value = false
    }
}

// 图标数据
const icons = ref<IconColumn[]>([])

// 初始化加载图标数据
const loadIcons = async () => {
    try {
        const data = await ELECTRON_API.loadIcons()
        console.log('data----', data)
        icons.value = data.length > 0 ? data : []
    } catch (error) {
        console.error('加载图标失败:', error)
    }
}

const handleSave = async (row: fileColumn) => {
    try {
        await loadIcons()
        // 准备要保存的数据，假设 row 包含 name 和 content 字段
        const svgData = {
            id: dayjs().format('YYYYMMDDhhmmss'),
            name: row.name.replace(/\.svg$/i, ''),
            path: row.content,
            remark: row.remark,
            updateTime: dayjs().format('YYYY-MM-DD hh:mm:ss'),
            type: 'svg'
        };
        icons.value.push(svgData)
        const success = await ELECTRON_API.saveIcons(JSON.parse(JSON.stringify(icons.value)));
        if (success) {
            ElMessage.success('SVG 数据保存成功');
        } else {
            ElMessage.error('SVG 数据保存失败');
        }
    } catch (error) {
        console.error('保存 SVG 数据时出错:', error);
        ElMessage.error('保存 SVG 数据时出错');
    }
};
</script>
<style>
svg {
    width: 32px;
    height: 32px;
}
</style>