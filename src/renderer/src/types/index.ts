export type IconColumn = {
  id: string;
  name: string;
  path: string;
  file?: File | null;
  remark?: string;
  updateTime?: string;
}

export type fileColumn = {
  name: string;
  content: string;
  updateTime?: string;
  remark?: string;
}