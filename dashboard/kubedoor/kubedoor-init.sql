CREATE DATABASE IF NOT EXISTS kubedoor ENGINE=Atomic;


CREATE TABLE IF NOT EXISTS kubedoor.k8s_res_control
(
    env String,
    namespace String,
    deployment String,
    pod_count_init UInt8 DEFAULT 0 COMMENT '初始化pod数,仅首次记录该值,从当前pod数复制',
    pod_count UInt8 DEFAULT 0 COMMENT '当前pod数,第三优先级',
    pod_count_manual Int16 DEFAULT -1 COMMENT '手动填写需要的pod数,第一优先级,webhook拦截时读取到-1,则取pod_count_ai',
    p95_pod_cpu_pct Float32 DEFAULT -1,
    p95_pod_mem_pct Float32 DEFAULT -1,
    request_cpu_m Int32 DEFAULT -1 COMMENT '取自高峰期的p95 CPU负载,最小1,新建服务时,该值默认为-1,webhook拦截时读取到-1,则不改变改字段,并通知。',
    request_mem_mb Int32 DEFAULT -1 COMMENT '取自高峰期的p95 内存使用量,最小1,新建服务时,该值默认为-1,webhook拦截时读取到-1,则不改变改字段,并通知。',
    limit_cpu_m Int32 DEFAULT -1 COMMENT '初始化的时候取当前pod的limit cpu,没有则为-1,webhook拦截时读取到-1,则不改变改字段,并通知。',
    limit_mem_mb Int32 DEFAULT -1 COMMENT '初始化的时候取当前pod的limit mem,没有则为-1,webhook拦截时读取到-1,则不改变改字段,并通知。',
    update DateTime('Asia/Shanghai'),
    pod_mem_saved_mb Float32 DEFAULT -1,
    pod_qps Float32 DEFAULT -1,
    pod_g1gc_qps Float32 DEFAULT -1,
    pod_count_ai Int16 DEFAULT -1 COMMENT 'AI计算后需要的pod数,第二优先级,webhook拦截时读取到-1,则取pod_count',
    pod_qps_ai Float32 DEFAULT -1,
    pod_load_ai Float32 DEFAULT -1,
    pod_g1gc_qps_ai Float32 DEFAULT -1,
    update_ai DateTime('Asia/Shanghai')
)
ENGINE = MergeTree
PRIMARY KEY (env,namespace,deployment)
ORDER BY (env,namespace,deployment)
SETTINGS index_granularity = 8192;


CREATE TABLE IF NOT EXISTS kubedoor.k8s_resources
(
    date DateTime('Asia/Shanghai'),
    env String,
    namespace String,
    deployment String,
    pod_count UInt8,
    p95_pod_load Float32,
    p95_pod_cpu_pct Float32,
    p95_pod_wss_mb Float32,
    p95_pod_wss_pct Float32,
    limit_pod_cpu_m Float32,
    limit_pod_mem_mb Float32,
    request_pod_cpu_m Float32,
    request_pod_mem_mb Float32,
    p95_pod_qps Float32,
    p95_pod_g1gc_qps Float32,
    pod_jvm_max_mb Float32
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(date)
PRIMARY KEY (date,env,namespace,deployment)
ORDER BY (date,env,namespace,deployment)
TTL toDateTime(date) + toIntervalDay(365)
SETTINGS index_granularity = 8192;