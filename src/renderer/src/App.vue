<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const ELECTRON_API = (window as any).api

// 图标数据
const icons = ref([])

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
  currentIcon.value = { id: 0, name: '', path: '', file: null, remark: '' }
  dialogVisible.value = true
}

// 触发文件选择
const handleFileSelect = () => {
  fileInputRef.value?.click()
}

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
  if (currentIcon.value.file) {
    // 这里可以添加文件上传逻辑，例如使用 FileReader 读取文件内容
    await new Promise<void>((resolve) => {
      const reader = new FileReader()
      reader.readAsDataURL(currentIcon.value.file)
      reader.onload = () => {
        currentIcon.value.path = reader.result as string
        resolve()
      }
    })
  }

  if (isEdit.value) {
    const index = icons.value.findIndex(item => item.id === currentIcon.value.id)
    if (index !== -1) {
      icons.value[index] = { ...currentIcon.value }
      ElMessage.success('修改成功')
    }
  } else {
    const newId = icons.value.length > 0 ? Math.max(...icons.value.map(item => item.id)) + 1 : 1
    icons.value.push({ ...currentIcon.value, id: newId })
    ElMessage.success('新增成功')
  }
  dialogVisible.value = false
  await saveIcons()
}
</script>

<template>
  <div class="p-5">
    <!-- 搜索框 -->
    <div class="mb-5 flex items-center">
      <input v-model="searchKeyword" type="text" placeholder="搜索图标..."
        class="w-full p-2 h-[26px] border border-gray-300 rounded-md" />
      <el-button type="primary" @click="handleAdd" class="ml-[8px]">新增</el-button>
    </div>

    <!-- ElementPlus 表格 -->
    <el-table :data="filteredIcons" class="w-full">
      <el-table-column prop="name" label="图标名称" min-width="100" />
      <el-table-column label="图标" width="80">
        <template #default="scope">
          <img v-if="scope.row.path" :src="scope.row.path" alt="图标" class="w-[32px] h-[32px] object-contain" />
        </template>
      </el-table-column>
      <el-table-column prop="remark" min-width="200" label="备注" />
      <el-table-column label="操作" width="140">
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
        <el-form-item label="图标文件">
          <input ref="fileInputRef" type="file" accept=".png" style="display: none" @change="handleFileChange" />
          <el-button @click="handleFileSelect">选择 PNG 文件</el-button>
          <span v-if="currentIcon.file" class="ml-2">{{ currentIcon.file.name }}</span>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="currentIcon.remark" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="flex justify-end space-x-2">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSave">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>