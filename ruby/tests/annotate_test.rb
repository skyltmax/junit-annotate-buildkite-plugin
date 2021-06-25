require "minitest/autorun"
require "open3"

describe "Junit annotate plugin parser" do
  it "handles no failures" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/no-test-failures/")

    assert_equal <<~OUTPUT, output
      Parsing junit-1.xml
      Parsing junit-2.xml
      Parsing junit-3.xml
      --- ✍️ Preparing annotation
      8 testcases found
      There were no failures/errors 🙌
      **8 testcases and no failures:**\n
    OUTPUT

    assert_equal 0, status.exitstatus
  end

  it "handles failures across multiple files" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/two-test-failures/")

    assert_equal <<~OUTPUT, output
      Parsing junit-1.xml
      Parsing junit-2.xml
      Parsing junit-3.xml
      --- ✍️ Preparing annotation
      6 testcases found
      There are 4 failures/errors 😭
      **6 testcases and 4 failures:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "handles failures and errors across multiple files" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/test-failure-and-error/")

    assert_equal <<~OUTPUT, output
      Parsing junit-1.xml
      Parsing junit-2.xml
      Parsing junit-3.xml
      --- ✍️ Preparing annotation
      6 testcases found
      There are 4 failures/errors 😭
      **6 testcases, 2 failures, and 2 errors:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "accepts custom regex filename patterns for job id" do
    output, status = Open3.capture2e("env",
                                     "BUILDKITE_PLUGIN_JUNIT_ANNOTATE_JOB_UUID_FILE_PATTERN=junit-(.*)-custom-pattern.xml", "#{__dir__}/../bin/annotate", "#{__dir__}/custom-job-uuid-pattern/")

    assert_equal <<~OUTPUT, output
      Parsing junit-123-456-custom-pattern.xml
      --- ✍️ Preparing annotation
      2 testcases found
      There is 1 failure/error 😭
      **2 testcases and 1 failure:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      in <a href="#123-456">Job #123-456</a>
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "uses the file path instead of classname for annotation content when specified" do
    output, status = Open3.capture2e("env", "BUILDKITE_PLUGIN_JUNIT_ANNOTATE_FAILURE_FORMAT=file",
                                     "#{__dir__}/../bin/annotate", "#{__dir__}/test-failure-and-error/")

    assert_equal <<~OUTPUT, output
      Parsing junit-1.xml
      Parsing junit-2.xml
      Parsing junit-3.xml
      --- ✍️ Preparing annotation
      6 testcases found
      There are 4 failures/errors 😭
      **6 testcases, 2 failures, and 2 errors:**\n
      <details>
      <summary><code>./spec/models/account_spec.rb: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
      <details>
      <summary><code>./spec/models/account_spec.rb: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>./spec/models/account_spec.rb: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>./spec/models/account_spec.rb: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "handles failures across multiple files in sub dirs" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/tests-in-sub-dirs/")

    assert_equal <<~OUTPUT, output
      Parsing sub-dir/junit-1.xml
      Parsing sub-dir/junit-2.xml
      Parsing sub-dir/junit-3.xml
      --- ✍️ Preparing annotation
      6 testcases found
      There are 4 failures/errors 😭
      **6 testcases and 4 failures:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</code></summary>\n
      <p>expected: 700 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 700
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>Failure/Error: expect(account.maximum_jobs_added_by_pipeline_changer).to eql(250)

        expected: 250
             got: 500

        (compared using eql?)
      ./spec/models/account_spec.rb:78:in `block (3 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/database.rb:16:in `block (2 levels) in &lt;top (required)&gt;&#39;
      ./spec/support/log.rb:17:in `run&#39;
      ./spec/support/log.rb:66:in `block (2 levels) in &lt;top (required)&gt;&#39;</code></pre>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "handles empty failure bodies" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/empty-failure-body/")

    assert_equal <<~OUTPUT, output
      Parsing junit.xml
      --- ✍️ Preparing annotation
      2 testcases found
      There is 1 failure/error 😭
      **2 testcases and 1 failure:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "handles missing message attributes" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/missing-message-attribute/")

    assert_equal <<~OUTPUT, output
      Parsing junit.xml
      --- ✍️ Preparing annotation
      4 testcases found
      There are 3 failures/errors 😭
      **4 testcases, 1 failure, and 2 errors:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 100 by default</code></summary>\n
      </details>

      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 50 by default</code></summary>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "handles cdata formatted XML files" do
    output, status = Open3.capture2e("#{__dir__}/../bin/annotate", "#{__dir__}/failure-with-cdata/")

    assert_equal <<~OUTPUT, output
      Parsing junit.xml
      --- ✍️ Preparing annotation
      2 testcases found
      There is 1 failure/error 😭
      **2 testcases and 1 error:**\n
      <details>
      <summary><code>spec.models.account_spec: Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</code></summary>\n
      <p>expected: 250 got: 500 (compared using eql?)</p>\n
      <pre><code>First line of failure output
            Second line of failure output</code></pre>\n
      </details>
    OUTPUT

    assert_equal 64, status.exitstatus
  end

  it "reports specified amount of slowest tests" do
    output, status = Open3.capture2e("env", "BUILDKITE_PLUGIN_JUNIT_ANNOTATE_REPORT_SLOWEST=5",
                                     "#{__dir__}/../bin/annotate", "#{__dir__}/no-test-failures/")

    assert_equal <<~OUTPUT, output
      Parsing junit-1.xml
      Parsing junit-2.xml
      Parsing junit-3.xml
      --- ✍️ Preparing annotation
      8 testcases found
      There were no failures/errors 🙌
      Reporting slowest tests ⏱
      **8 testcases and no failures:**\n
      <details>
      <summary>5 slowest tests</summary>\n
      <table>
      <thead><tr><th>Unit</th><th>Test</th><th>Time</th></tr></thead>
      <tbody>
      <tr><td>spec.models.account_spec</td><td>Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</td><td>0.977127</td></tr>
      <tr><td>spec.models.account_spec</td><td>Account#maximum_jobs_added_by_pipeline_changer returns 250 by default</td><td>0.967127</td></tr>
      <tr><td>spec.models.account_spec</td><td>Account#maximum_jobs_added_by_pipeline_changer returns 500 if the account is ABC</td><td>0.620013</td></tr>
      <tr><td>spec.models.account_spec</td><td>Account#maximum_jobs_added_by_pipeline_changer returns 900 if the account is F00</td><td>0.520013</td></tr>
      <tr><td>spec.models.account_spec</td><td>Account#maximum_jobs_added_by_pipeline_changer returns 700 if the account is XYZ</td><td>0.420013</td></tr>
      </tbody>
      </table>
      </details>
    OUTPUT

    assert_equal 0, status.exitstatus
  end
end
