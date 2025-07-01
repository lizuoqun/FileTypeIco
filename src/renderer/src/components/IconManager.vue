<script setup lang="ts">
import { ElMessage } from 'element-plus'
import dayjs from 'dayjs';

const ELECTRON_API = (window as any).api

type IconColumn = {
  id: number;
  name: string;
  path: string;
  file?: File | null;
  remark?: string;
  updateTime?: string;
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

onMounted(() => {
  loadIcons()
})

// 保存图标数据到本地
const saveIcons = async () => {
  // 过滤 icons 数据，确保可序列化
  const serializableIcons = JSON.parse(JSON.stringify(icons.value))
  const success = await ELECTRON_API.saveIcons(serializableIcons)
  if (!success) {
    ElMessage.error('保存图标数据失败')
  }
}

// 搜索关键词Set-ExecutionPolicy RemoteSigned
const searchKeyword = ref('')

// 过滤后的图标数据
const filteredIcons = computed(() => {
  if (!searchKeyword.value) return icons.value
  return icons.value.filter(icon =>
    icon.name.toLowerCase().includes(searchKeyword.value.toLowerCase())
  )
})

// 对话框相关
const dialogVisible = ref(false)
const isEdit = ref(false)
const currentIcon = ref({ id: 0, name: '', path: '', file: null as File | null, remark: '' })
const fileInputRef = ref<HTMLInputElement | null>(null)

// 打开新增对话框
const handleAdd = () => {
  isEdit.value = false
  currentIcon.value = initRow()
  dialogVisible.value = true
}

const initRow = () => {
  return { id: 0, name: '', path: '', file: null, remark: '' }
}

// 触发文件选择
const handleFileSelect = () => {
  fileInputRef.value?.click()
}

const clearIconFile = () => {
  currentIcon.value.file = null;
  currentIcon.value.path = '';
  if (fileInputRef.value) {
    fileInputRef.value.value = '';
  }
};

// 文件变化处理
const handleFileChange = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    currentIcon.value.file = input.files[0]
  }
}

// 打开编辑对话框
const handleEdit = (row: any) => {
  isEdit.value = true
  currentIcon.value = { ...row }
  console.log('edit ---- ', currentIcon.value)
  dialogVisible.value = true
}

// 删除操作
const handleDelete = async (row: any) => {
  const index = icons.value.findIndex(item => item.id === row.id)
  if (index !== -1) {
    icons.value.splice(index, 1)
    ElMessage.success('删除成功')
    await saveIcons()
  }
}

// 保存操作
const handleSave = async () => {
  const currentTime = dayjs().format('YYYY-MM-DD HH:mm:ss');
  if (isEdit.value) {
    const index = icons.value.findIndex(item => item.id === currentIcon.value.id)
    if (index !== -1) {
      icons.value[index] = { ...currentIcon.value, updateTime: currentTime }
      ElMessage.success('修改成功')
    }
  } else {
    const newId = icons.value.length > 0 ? Math.max(...icons.value.map(item => item.id)) + 1 : 1
    icons.value.push({ ...currentIcon.value, id: newId, updateTime: currentTime })
    ElMessage.success('新增成功')
  }
  dialogVisible.value = false
  await saveIcons()
}

// 关闭弹框，清空数据
const handleCancel = () => {
  dialogVisible.value = false
  currentIcon.value = initRow()
}


const handleAvatarChange = (file) => {
  return new Promise((resolve) => {
    const reader = new FileReader()
    reader.readAsDataURL(file.raw)
    reader.onload = () => {
      currentIcon.value.path = reader.result as string
      resolve(true)
    }
  })
}

const beforeAvatarUpload = (file) => {
  const isPng = file.type === 'image/png'
  if (!isPng) {
    ElMessage.error('只能上传 PNG 格式的图片！')
  }
  return isPng
}

</script>

<template>
  <div class="p-2 pt-0">
    <!-- 搜索框 -->
    <div class="mb-2 flex items-center">
      <el-input v-model="searchKeyword" type="text" placeholder="搜索图标..." class="w-full" />
      <el-button type="primary" @click="handleAdd" class="ml-[8px]">新增</el-button>
    </div>

    <!-- ElementPlus 表格 -->
    <el-table :data="filteredIcons" class="w-full" stripe border show-overflow-tooltip height="500px">
      <el-table-column prop="name" label="图标名称" min-width="100" />
      <el-table-column label="图标" width="80">
        <template #default="scope">
          <img v-if="scope.row.path" :src="scope.row.path" alt="图标" class="w-[32px] h-[32px] object-contain" />
        </template>
      </el-table-column>
      <el-table-column prop="updateTime" width="180" label="更新时间" align="center" />
      <el-table-column prop="remark" min-width="200" label="备注" />
      <el-table-column label="操作" width="140" align="center">
        <template #default="scope">
          <el-button link @click="handleEdit(scope.row)">编辑</el-button>
          <el-button link type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑图标' : '新增图标'">
      <el-form label-width="80px" label-position="left">
        <el-form-item label="名称">
          <el-input v-model="currentIcon.name" />
        </el-form-item>

        <el-form-item label="图标文件" v-if="false">
          <template v-if="currentIcon.path">
            <img :src="currentIcon.path" alt="Selected Icon"
              style="max-width: 100px; max-height: 100px; margin-bottom: 10px;" />
            <el-button type="danger" @click="clearIconFile">删除</el-button>
          </template>
          <template v-else>
            <input ref="fileInputRef" type="file" accept=".png" style="display: none" @change="handleFileChange" />
            <el-button @click="handleFileSelect">请上传图标</el-button>
          </template>
        </el-form-item>

        <el-form-item label="图标文件">
          <el-upload class="avatar-uploader" :show-file-list="false" :before-upload="beforeAvatarUpload"
            :on-change="handleAvatarChange">
            <img v-if="currentIcon.path" :src="currentIcon.path" class="avatar"
              style="max-width: 100px; max-height: 100px;" />
            <el-icon v-else class="avatar-uploader-icon">
              <Plus />
            </el-icon>
          </el-upload>
        </el-form-item>

        <el-form-item label="备注">
          <el-input v-model="currentIcon.remark" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="flex justify-end">
          <el-button @click="handleCancel">取消</el-button>
          <el-button type="primary" @click="handleSave">确定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.avatar-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  text-align: center;
}

.avatar {
  width: 100px;
  height: 100px;
  display: block;
}
</style>
