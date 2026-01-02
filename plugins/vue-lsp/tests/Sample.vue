<template>
  <div class="user-card">
    <header>
      <h2>{{ displayName }}</h2>
      <span class="badge" :class="statusClass">{{ user.status }}</span>
    </header>

    <div class="user-info">
      <p>Email: {{ user.email }}</p>
      <p v-if="user.age">Age: {{ user.age }}</p>
      <p>Member since: {{ formattedDate }}</p>
    </div>

    <div class="actions">
      <button @click="handleEdit" class="btn btn-primary">
        Edit Profile
      </button>
      <button @click="toggleStatus" class="btn btn-secondary">
        Toggle Status
      </button>
    </div>

    <div v-if="isEditing" class="edit-form">
      <input v-model="editForm.name" placeholder="Name" />
      <input v-model="editForm.email" type="email" placeholder="Email" />
      <button @click="saveChanges" class="btn btn-success">Save</button>
      <button @click="cancelEdit" class="btn btn-danger">Cancel</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

/**
 * User interface matching the backend API.
 */
interface User {
  id: number
  name: string
  email: string
  age?: number
  status: 'active' | 'inactive' | 'pending'
  createdAt: Date
}

/**
 * Edit form data interface.
 */
interface EditForm {
  name: string
  email: string
}

// Props
interface Props {
  userId: number
  showActions?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showActions: true,
})

// Emits
const emit = defineEmits<{
  update: [user: User]
  delete: [userId: number]
}>()

// Reactive state
const user = ref<User>({
  id: props.userId,
  name: 'John Doe',
  email: 'john.doe@example.com',
  age: 30,
  status: 'active',
  createdAt: new Date('2024-01-01'),
})

const isEditing = ref(false)
const editForm = ref<EditForm>({
  name: '',
  email: '',
})

// Computed properties
const displayName = computed(() => {
  return user.value.name.toUpperCase()
})

const statusClass = computed(() => {
  return {
    'badge-success': user.value.status === 'active',
    'badge-warning': user.value.status === 'pending',
    'badge-danger': user.value.status === 'inactive',
  }
})

const formattedDate = computed(() => {
  return user.value.createdAt.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
})

// Methods
function handleEdit() {
  isEditing.value = true
  editForm.value = {
    name: user.value.name,
    email: user.value.email,
  }
}

function cancelEdit() {
  isEditing.value = false
  editForm.value = { name: '', email: '' }
}

function saveChanges() {
  user.value.name = editForm.value.name
  user.value.email = editForm.value.email
  isEditing.value = false
  emit('update', user.value)
}

function toggleStatus() {
  const statuses: Array<User['status']> = ['active', 'inactive', 'pending']
  const currentIndex = statuses.indexOf(user.value.status)
  const nextIndex = (currentIndex + 1) % statuses.length
  user.value.status = statuses[nextIndex]
}

// TODO: Add user avatar support
// FIXME: Handle API errors gracefully

// Lifecycle
onMounted(() => {
  console.log(`User component mounted for user ${props.userId}`)
})

// Expose methods for parent components
defineExpose({
  handleEdit,
  toggleStatus,
})
</script>

<style scoped>
.user-card {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1.5rem;
  max-width: 400px;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e0e0e0;
}

h2 {
  margin: 0;
  font-size: 1.5rem;
  color: #333;
}

.badge {
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.875rem;
  font-weight: 600;
}

.badge-success {
  background-color: #4caf50;
  color: white;
}

.badge-warning {
  background-color: #ff9800;
  color: white;
}

.badge-danger {
  background-color: #f44336;
  color: white;
}

.user-info {
  margin-bottom: 1rem;
}

.user-info p {
  margin: 0.5rem 0;
  color: #666;
}

.actions {
  display: flex;
  gap: 0.5rem;
  margin-top: 1rem;
}

.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  transition: opacity 0.2s;
}

.btn:hover {
  opacity: 0.8;
}

.btn-primary {
  background-color: #2196f3;
  color: white;
}

.btn-secondary {
  background-color: #9e9e9e;
  color: white;
}

.btn-success {
  background-color: #4caf50;
  color: white;
}

.btn-danger {
  background-color: #f44336;
  color: white;
}

.edit-form {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #e0e0e0;
}

.edit-form input {
  width: 100%;
  padding: 0.5rem;
  margin-bottom: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.edit-form button {
  margin-right: 0.5rem;
}
</style>
